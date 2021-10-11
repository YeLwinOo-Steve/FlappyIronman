import 'package:flutter/material.dart';

class Block extends StatelessWidget {
  final blockWidth; // out of 2, where 2 is the width of the screen
  final blockHeight; // proportion of the screenheight
  final blockX;
  final bool hasBottomBlock;

  Block(
      {this.blockHeight,
      this.blockWidth,
      required this.hasBottomBlock,
      this.blockX});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * blockX + blockWidth) / (2 - blockWidth),
          hasBottomBlock ? 1 : -1),
      child: Material(
        elevation: 10.0,
        child: Container(
          color: Colors.green,
          width: MediaQuery.of(context).size.width * blockWidth / 2,
          height: MediaQuery.of(context).size.height * 3 / 4 * blockHeight / 2,
        ),
      ),
    );
  }
}
