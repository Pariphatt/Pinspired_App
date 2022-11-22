import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../service/database_service.dart';
import '../service/storage_service.dart';
import '../themes/color.dart';
import '../utils/showSnackBar.dart';
import '../widgets/input_decoration.dart';
import '../widgets/main_btn_widget.dart';
import '../widgets/uploadinput_decoration.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final formKey = GlobalKey<FormState>();
  String? description;
  File? imageFile;
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF68CBEB),
      body: Container(
        //Image.asset("assets/img.png", width: 170, height: 300),
        child: InkWell(
          onTap: () {
            // FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 100),
                alignment: Alignment.bottomLeft,
                child: Text('UPLOAD',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: kColorsWhite)),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: ListView(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: InkWell(
                            onTap: () {
                              showButtomSheet(context);
                            },
                            child: Container(
                              width: 185,
                              height: 185,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: Color(0xFFCDCDCD),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              width: 322,
                              height: 166,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: Color(0xFF70CEEC),
                              ),
                              child: CreateDescription(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: InkWell(
                            onTap: () {},
                            child: MainBtnWidget(
                              colorBtn: kColorsSky,
                              textBtn: 'Upload your inspiration',
                              isTransparent: false,
                              haveIcon: false,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CreateDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter description";
          } else {
            return null;
          }
        },
        onChanged: (value) {
          description = value;
        },
        decoration: UploadInputDecorationWidget(
          context,
          "tell something about your inspiration. . .",
        ),
      ),
    );
  }

  Future<void> showButtomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Wrap(
              children: [
                ListTile(
                  onTap: () {
                    openGallery(context);
                  },
                  leading: SvgPicture.asset(
                    'assets/icons/gallery.svg',
                    color: kColorsPurple,
                  ),
                  title: Text('Gallery',
                      style: Theme.of(context).textTheme.subtitle1),
                ),
                ListTile(
                  onTap: () {
                    openCamera(context);
                  },
                  leading: SvgPicture.asset(
                    'assets/icons/camera.svg',
                    color: kColorsPurple,
                  ),
                  title: Text('Camera',
                      style: Theme.of(context).textTheme.subtitle1),
                )
              ],
            ),
          );
        });
  }

  openGallery(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No Image selected');
      }
    });
    Navigator.of(context).pop();
  }

  openCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No Image selected');
      }
    });
    Navigator.of(context).pop();
  }

  Future<void> confirmHandle({required context}) async {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);
    String? imageUrl;

    showDialog(
      context: context,
      builder: (context) => const Center(
          child: CircularProgressIndicator(
        strokeWidth: 4,
      )),
    );

    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    if (imageFile != null) {
      imageUrl = await storageService.uploadProductImage(imageFile: imageFile!);
    }
    // final newProduct = Product(
    //     type: Product.getProductType(productCategory!),
    //     name: productName!,
    //     price: double.parse(productPrice!),
    //     quantity: int.parse(productQuantity!),
    //     description: productDescription!,
    //     photoURL: imageUrl,
    //     uid: Uuid().v1());
    // databaseService.addProduct(product: newProduct);

    Navigator.of(context).pop();
    showSnackBar('Add product successful.', backgroundColor: Colors.green);
    Navigator.of(context).pop();
  }
}
