import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_party_indicator.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed("/home_page"));
    return Scaffold(
      body: Container(
        color: Colors.lightBlue,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/iron_man_loading.png",
              width: 500.0,
              height: 500.0,
            ),
            Loading(
                indicator: LineScalePartyIndicator(),
                size: 70.0,
                color: Colors.white),
            const SizedBox(height: 10.0),
            const Text(
              "by Ye Lwin Oo",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            )
          ],
        )),
      ),
    );
  }
}
