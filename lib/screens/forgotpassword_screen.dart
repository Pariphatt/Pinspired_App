import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:developer';
import 'package:cnc_shop/model/user_model.dart';
import 'package:cnc_shop/screens/forgotpassword_screen.dart';
import 'package:cnc_shop/service/auth_service.dart';
import 'package:cnc_shop/themes/color.dart';
import 'package:cnc_shop/widgets/input_decoration.dart';
import 'package:cnc_shop/widgets/main_btn_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/showSnackBar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorsSky,
      ),
      body: InkWell(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Container(
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/bg.jpg"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: kColorsWhite,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Receive an email',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: kColorsBlack),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        cursorColor: Colors.white,
                        decoration: InputDecorationWidget(context, "Email"),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // ElevatedButton.icon(
                      //   style: ElevatedButton.styleFrom(
                      //     minimumSize: Size.fromHeight(50),
                      //   ),
                      //   icon: Icon(Icons.email_outlined),
                      //   label: Text(
                      //     'Reset Password',
                      //   ),
                      //   onPressed: () {
                      //     resetPassword();
                      //   },
                      // )
                      MainBtnWidget(
                        colorBtn: kColorsSky,
                        textBtn: 'Reset Password',
                        fontWeight: FontWeight.w800,
                        textColor: kColorsWhite,
                        isTransparent: false,
                        haveIcon: false,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showSnackBar('success', backgroundColor: Colors.green);
      Navigator.of(context).popUntil((route) => route.isCurrent);
    } on FirebaseAuthException catch (e) {
      print(e);
      showSnackBar(e.message);
      // Navigator.of(context).pop();
    }
  }
}
