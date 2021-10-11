import 'package:flutter/material.dart';

class IronManImg extends StatelessWidget {
  final yAxis;
  final double manWidth; // normal double value for width.
  final double manHeight; // out of 2, 2 being the entire height of the screen

  IronManImg({this.yAxis, required this.manWidth, required this.manHeight});
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0, (2 * yAxis + manHeight) / (2 - manHeight)),
        child: Image.asset(
          'assets/iron_man_fly.png',
          width: MediaQuery.of(context).size.height * manWidth / 2,
          height: MediaQuery.of(context).size.height * 3 / 4 * manHeight / 2,
          fit: BoxFit.fill,
        ));
  }
}
