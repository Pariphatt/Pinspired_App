import 'dart:developer';

import 'package:cnc_shop/model/user_model.dart';
import 'package:cnc_shop/screens/forgotpassword_screen.dart';
import 'package:cnc_shop/service/auth_service.dart';
import 'package:cnc_shop/service/database_service.dart';
import 'package:cnc_shop/themes/color.dart';
import 'package:cnc_shop/utils/showSnackBar.dart';
import 'package:cnc_shop/widgets/input_decoration.dart';
import 'package:cnc_shop/widgets/main_btn_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment(0.2, 0.1),
                colors: [
                  Color(0xFF68CBEB),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
              image: DecorationImage(
                  image: AssetImage('assets/pinsprised_logo.png'),
                  alignment: Alignment(0, -0.9)),
              color: kColorsSky),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE5F8FE),
              Color(0xFFA9E0F1).withOpacity(0),
            ],
          ),

                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 0, top: 20, bottom: 20),
                    child: Text('Login Now',
                        style: TextStyle(
                            color: kColorsSky,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CreateEmail(),
                        CreatePassword(),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: InkWell(
                          onTap: () {
                            loginHandle(context: context);
                          },
                          child: MainBtnWidget(
                            colorBtn: Color(0xFF70CEEC),
                            textBtn: 'LOGIN',
                            isTransparent: false,
                            haveIcon: false,
                            height: 50,
                          ))),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: Text('Forgot Password?',
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: kColorsSky)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 40),
                    child: Container(
                        child: Row(children: [
                      Expanded(child: Divider(color: kColorsGrey)),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Don\'t have an account?",
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: kColorsGrey)),
                      ),
                      Expanded(child: Divider(color: kColorsGrey)),
                    ])),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: MainBtnWidget(
                              colorBtn: Color.fromARGB(255, 255, 255, 255),
                              textBtn: 'Sign Up',
                              fontWeight: FontWeight.w800,
                              textColor: Color.fromARGB(200, 119, 209, 237),
                              isTransparent: false,
                              haveIcon: false,
                              height: 50,
                            ))),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget CreateEmail() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kColorsPurple),
          decoration: InputDecorationWidget(context, 'Email'),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter Email";
            }
            return null;
          },
          onChanged: (value) {
            email = value;
          },
        ));
  }

  Widget CreatePassword() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: TextFormField(
          obscureText: true,
          keyboardType: TextInputType.text,
          autofocus: false,
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kColorsPurple),
          decoration: InputDecorationWidget(context, 'Password'),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter password";
            }
            return null;
          },
          onChanged: (value) {
            password = value;
          },
        ));
  }

  Future<void> loginHandle({required BuildContext context}) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      showDialog(
          context: context,
          builder: ((context) => Center(
                child: CircularProgressIndicator(strokeWidth: 4),
              )));

      try {
        await authService.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      } on auth.FirebaseAuthException catch (e) {
        log(e.message!);
        log(e.code);
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          showSnackBar("The email or password is incorrect");
        } else if (e.code == 'too-many-requests') {
          showSnackBar("Too many invalid, Please try again later");
        }
        Navigator.pop(context);
      }
    }
    // showDialog(
  }

  Future<void> _googleLoginHandle({required BuildContext context}) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    try {
      await googleSignIn.signOut();

      await googleSignIn.signIn();

      String email = googleSignIn.currentUser!.email;
      final databaseService =
          Provider.of<DatabaseService>(context, listen: false);

      if (await databaseService.getUserFormEmail(email: email) == null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/registerGoogle', (route) => false,
            arguments: email);
      } else {
        await authService.signInWithEmail(email: email);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/homepage', (route) => false);
      }
    } catch (error) {
      print(error);
    }
  }

  bool emailValidator(String email) => RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .hasMatch(email);
}
