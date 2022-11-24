import 'dart:developer';

// import 'package:aesthetic_dialogs/aesthetic_dialogs.dart';
import 'package:cnc_shop/model/user_model.dart';
import 'package:cnc_shop/service/auth_service.dart';
import 'package:cnc_shop/themes/color.dart';
import 'package:cnc_shop/widgets/coin_menu_widget.dart';
import 'package:cnc_shop/widgets/main_btn_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.currentUser().then((currentUser) {
      setState(() {
        user = currentUser;
      });
    });

    return Scaffold(
      backgroundColor: kColorsWhite,
      body: SizedBox(
        height: 680,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  child: InkWell(
                    onTap: () {
                      // logoutHandle(context: context);
                    },
                    child: Image.asset("assets/profile_background.png",
                        width: 400, height: 306),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              height: 500,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset("assets/pgback.png",
                                      width: 400, height: 306),
                                  Text(
                                    "This is caption zone, you can description your image",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Close"))
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: MainBtnWidget(
                      colorBtn: kColorsRed,
                      textBtn: 'TestDialog',
                      isTransparent: false,
                      haveIcon: false),
                ),
              ),
              SizedBox(
                height: 220,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: InkWell(
                  onTap: () {
                    logoutHandle(context: context);
                  },
                  child: MainBtnWidget(
                      colorBtn: kColorsSky,
                      textBtn: 'Logout',
                      isTransparent: false,
                      haveIcon: false),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Create Profile and Coin Menu

  // Create Setting Menu

  Future<void> logoutHandle({required BuildContext context}) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } on auth.FirebaseAuthException catch (e) {
      log(e.message!);
    }
  }
}
