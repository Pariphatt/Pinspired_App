import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cnc_shop/model/post_model.dart';
import 'package:cnc_shop/screens/login_screen.dart';
import 'package:cnc_shop/service/database_service.dart';
import 'package:cnc_shop/service/storage_service.dart';
import 'package:cnc_shop/themes/color.dart';
import 'package:cnc_shop/utils/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../model/request_model.dart';
import '../model/user_model.dart';
import '../service/auth_service.dart';

class AnotherProfileScreen extends StatefulWidget {
  AnotherProfileScreen({Key? key}) : super(key: key);

  @override
  State<AnotherProfileScreen> createState() => _AnotherProfileScreen();
}

class _AnotherProfileScreen extends State<AnotherProfileScreen> {
  User? user;
  String? anotherUsername;
  String? imageUrl;
  File? imageFile;
  String keyword = '';
  final picker = ImagePicker();
  String? description;
  int? money;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    String value = '';
    int coin = 0;
    User another = ModalRoute.of(context)!.settings.arguments as User;
    // print(another.username);

    authService.currentUser().then((currentUser) {
      setState(() {
        user = currentUser;
      });
    });

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
            child: Icon(
              size: 35,
              Icons.arrow_back,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: user == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment(0.4, 0.1),
                    colors: [
                      Color(0xFF68CBEB),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    imageFile == null
                        ? Stack(
                            alignment: Alignment.topLeft,
                            children: <Widget>[
                                CachedNetworkImage(
                                  width: double.infinity,
                                  fit: BoxFit.fill,
                                  imageUrl: another.coverImageUrl!,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ])
                        : Stack(alignment: Alignment.bottomRight, children: <
                            Widget>[
                            ClipRRect(
                              // borderRadius: BorderRadius.circular(10),
                              child: imageFile == null
                                  ? CachedNetworkImage(
                                      imageUrl: user!.coverImageUrl!,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                                  : Image.file(imageFile!, fit: BoxFit.cover),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10, bottom: 10),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      imageFile = null;
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      submit(context: context);
                                    },
                                    child: Icon(
                                      Icons.check,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                    BlurryContainer(
                      // padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                      blur: 25,
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 15, bottom: 15),
                      borderRadius: const BorderRadius.all(Radius.circular(0)),
                      child: Row(
                        children: [
                          Text("${another!.username ?? "Unknown"}",
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w700)),
                          Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kColorsSky,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                            ),
                            onPressed: () async {
                              print("Tap on request");
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        content: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Tip to ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    "${another.username}",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                                  ),
                                                  Spacer(),
                                                  InkWell(
                                                    onTap: () => {
                                                      Navigator.pop(context)
                                                    },
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 30,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              TextField(
                                                keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: 5,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Why you tip to this user?",
                                                  labelStyle: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.grey),
                                                ),
                                                onChanged: (text) {
                                                  description = text;
                                                },
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: TextField(
                                                      keyboardType: TextInputType.number,
                                                      inputFormatters: <TextInputFormatter>[
                                                        FilteringTextInputFormatter.digitsOnly
                                                        ],
                                                      
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "coins",
                                                        labelStyle: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            color: Colors.grey),
                                                      ),
                                                      onChanged: (text) {
                                                        money = int.parse(text);
                                                      },
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.attach_money,
                                                    color: Color.fromARGB(
                                                        255, 255, 187, 0),
                                                  ),
                                                  Spacer(),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          kColorsSky,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(32.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      if (user!.coin! < money!) {
                                                        Navigator.pop(context);
                                                        showSnackBar("Tip fail, coin not enought!", backgroundColor: Colors.red);
                                                        return;
                                                      }
                                                      Navigator.pop(context);
                                                      showSnackBar("Tip success", backgroundColor: Colors.green);
                                                      Request request = Request(
                                                        id: Uuid().v1(),
                                                        description: description,
                                                        cost: money!,
                                                        user_hirer: user!.uid,
                                                        user_workForHire: another.uid,);
                                                      user?.coin = user!.coin! - money!;
                                                      another.coin = another.coin! + money!;
                                                      databaseService.updateUserFromUid(uid: user!.uid, user: user!);
                                                      databaseService.updateUserFromUid(uid: another.uid, user: another);
                                                      databaseService.addRequest(request: request);
                                                    },
                                                    child: Text('confirm'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            child: const Text('Tip \$'),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: StreamBuilder<List<Post?>>(
                            stream: databaseService
                                .getStreamListPostOnlyMe(another.uid),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error.toString());
                                return Center(
                                  child: Text('An error occure.'),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                  child: Text('No Post'),
                                );
                              }
                              //return masonryLayout(context);})),

                              return MasonryGridView.builder(
                                scrollDirection: Axis.vertical,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index) {
                                  return snapshot.data?.length != 0
                                      ? InkWell(
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: InkWell(
                                                onTap: () async {
                                                  String? username =
                                                      await getUsername(
                                                          snapshot, index);
                                                  showDialog<String>(
                                                      context: context,
                                                      builder:
                                                          (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(5))),
                                                                content: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      children: <
                                                                          Widget>[
                                                                        Image(
                                                                            image:
                                                                                NetworkImage(snapshot.data?[index]!.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/cnc-shop-caa9d.appspot.com/o/covers%2Fdefualt_cover.png?alt=media&token=c16965aa-a181-4c12-b528-b23221c23e17")),
                                                                        Padding(
                                                                          // ignore: prefer_const_constructors
                                                                          padding: EdgeInsets.only(
                                                                              right: 10,
                                                                              top: 10),
                                                                          child:
                                                                              InkWell(
                                                                            child:
                                                                                // ignore: prefer_const_constructors
                                                                                Icon(
                                                                              Icons.close,
                                                                              color: Colors.white,
                                                                              size: 30,
                                                                            ),
                                                                            onTap: () =>
                                                                                Navigator.pop(context),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          const Text(
                                                                            "Upload by ",
                                                                            style: TextStyle(
                                                                                fontSize: 20,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontStyle: FontStyle.italic,
                                                                                color: Colors.grey),
                                                                          ),
                                                                          Text(
                                                                            "$username",
                                                                            style: TextStyle(
                                                                                fontSize: 22,
                                                                                fontWeight: FontWeight.w600,
                                                                                color: Colors.black),
                                                                          ),
                                                                          const Spacer(),
                                                                          Text(
                                                                            "${snapshot.data?[index]?.tag.toString().split('.')[1]}",
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FontStyle.italic,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            Text(
                                                                          "${snapshot.data?[index]?.description}",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ));
                                                },
                                                child: Image(
                                                  image: NetworkImage(snapshot
                                                          .data?[index]
                                                          ?.photoURL ??
                                                      ''),
                                                ),
                                              )))
                                      : Container(
                                          child: Center(
                                            child: Text("No Post"),
                                          ),
                                        );
                                },
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ));
  }

  Future<void> showNewButtomSheet(BuildContext context) {
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

  Widget masonryLayout(BuildContext context) {
    return MasonryGridView.builder(
      scrollDirection: Axis.vertical,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2),
      itemCount: 10,
      itemBuilder: (context, index) {
        // _images.add(Image.network("https://source.unsplash.com/random/$index"));
        print("masony layout run in profile screen");
        return InkWell(
          onTap: (() {
            // print(_images[index]);
          }),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              // child: _images[index],
              child:
                  Image.network("https://source.unsplash.com/random/$index")),
        );
      },
    );
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

  Future<void> submit({required context}) async {
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

    if (imageFile != null) {
      await storageService
          .uploadCoverImage(imageFile: imageFile!)
          .then((value) {
        if (value!.isNotEmpty) {
          print(value.toString());
          user!.coverImageUrl = value.toString();
        }
        databaseService.updateCoverFromUid(uid: user!.uid, user: user!);
        Navigator.of(context, rootNavigator: true).pop();
      }).catchError((error) {
        print(error.toString());
        Navigator.of(context, rootNavigator: true).pop();
      });
      print("upload complete");
    }

    // showSnackBar('Add product successful.', backgroundColor: Colors.green);
    imageFile = null;
  }

  Future<void> logoutHandle({required BuildContext context}) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signOut();
      print("logout success");
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => new LoginScreen()),
          (route) => false);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> getUsername(dynamic snapshot, dynamic index) async {
    final databaseService =
        Provider.of<DatabaseService>(context, listen: false);
    User? user;
    String? username;
    user = await databaseService.getUserFromUid(
        uid: snapshot.data?[index]?.userId);

    if (user!.username.isNotEmpty) {
      username = user.username;
      print(username);
    }
    return username;
  }
}
