import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../themes/color.dart';
import '../widgets/main_btn_widget.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
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
                child: Text('REQUEST',
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
                      child: ListView(children: [request()]),
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

  Widget request() {
    return Stack(
      children: [
        Container(
          height: 325,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          top: 50,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Container(
                  child: Row(),
                  height: 240,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: kColorsWhite,
                      boxShadow: [
                        BoxShadow(
                          color: kColorsBlack.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
