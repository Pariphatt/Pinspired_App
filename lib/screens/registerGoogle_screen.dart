import 'dart:developer';

import 'package:cnc_shop/service/auth_service.dart';
import 'package:cnc_shop/themes/color.dart';
import 'package:cnc_shop/utils/showSnackBar.dart';
import 'package:cnc_shop/widgets/input_decoration.dart';
import 'package:cnc_shop/widgets/main_btn_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class RegisterGoogleScreen extends StatefulWidget {
  RegisterGoogleScreen({Key? key}) : super(key: key);

  @override
  State<RegisterGoogleScreen> createState() => _RegisterGoogleScreenState();
}

class _RegisterGoogleScreenState extends State<RegisterGoogleScreen> {
  final formKey = GlobalKey<FormState>();
  String? phone, address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorsPurple,
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage("assets/bg.jpg"),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back.svg', color: kColorsWhite),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: kColorsWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 40, bottom: 20),
              child: Text('Register',
                  style: Theme.of(context).textTheme.headline1),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CreateUsername(),
                  CreateEmail(),
                  CreatePhone(),
                  CreateAddress(),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: InkWell(
                    onTap: () {
                      registerHandle(context: context);
                    },
                    child: MainBtnWidget(
                        colorBtn: kColorsPurple,
                        textBtn: 'Sign Up',
                        isTransparent: false,
                        haveIcon: false))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: Container(
                  child: Row(children: [
                Expanded(child: Divider(color: kColorsGrey)),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("or",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: kColorsGrey)),
                ),
                Expanded(child: Divider(color: kColorsGrey)),
              ])),
            ),
            SizedBox(height: 10),
            InkWell(
                onTap: () {},
                child: MainBtnWidget(
                    colorBtn: kColorsPurple,
                    textBtn: 'Sign Up with Google',
                    isTransparent: true,
                    haveIcon: true)),
            SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget CreateUsername() {
    final username =
        ModalRoute.of(context)!.settings.arguments.toString().split("@")[0];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Text('Username: $username',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kColorsPurple)),
    );
  }

  Widget CreateEmail() {
    final email =
        ModalRoute.of(context)!.settings.arguments.toString().split(",")[0];
    print(email.toString());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: Text('Email: $email',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kColorsPurple)),
    );
  }

  Widget CreatePhone() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
          autofocus: false,
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kColorsPurple),
          decoration: InputDecorationWidget(context, 'Phone'),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter phone";
            }
            return null;
          },
          onChanged: (value) {
            phone = value;
          },
        ));
  }

  Widget CreateAddress() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kColorsPurple),
          decoration: InputDecorationWidget(context, 'Address'),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter Address";
            }
            return null;
          },
          onChanged: (value) {
            address = value;
          },
        ));
  }

  Future<void> registerHandle({required BuildContext context}) async {
    final email = ModalRoute.of(context)!.settings.arguments;
    final username =
        ModalRoute.of(context)!.settings.arguments.toString().split("@")[1];

    final authService = Provider.of<AuthService>(context, listen: false);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      showDialog(
          context: context,
          builder: ((context) => Center(
                child: CircularProgressIndicator(strokeWidth: 4),
              )));
      try {
        await authService.createUserGoogle(
            email: email,
            uid: email,
            username: username,
            phone: phone,
            address: address);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      } on auth.FirebaseAuthException catch (e) {
        log(e.message!);
        showSnackBar(e.message);
        Navigator.of(context).pop();
      }
    }
  }
}
