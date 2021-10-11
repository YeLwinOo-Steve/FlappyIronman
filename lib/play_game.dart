import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'block.dart';
import 'constants.dart';
import 'iron_man_img.dart';

class PlayGame extends StatefulWidget {
  @override
  _PlayGameState createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  static const String HIGH_SCORE_KEY = 'highScore';
  static double yAxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = yAxis;
  bool isStarted = false;
  int score = 0;
  int highScore = 0;
  late Timer scoreTimer;

  double gravity = -4.9;
  double velocity = 2.5;
  double manWidth = 0.2;
  double manHeight = 0.3;

  static List<double> blockX = [
    0.7,
    0.7 + 1.3,
    0.7 + 2.6,
    0.7 + 3.9,
    0.7 + 5.2
  ];
  static double blockWidth = 0.4; // out of 2
  List<List<double>> blockHeight = [
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.3, 0.7],
    [0.7, 0.3],
    [0.5, 0.5],
    [0.4, 0.6]
  ];

  @override
  void initState() {
    super.initState();
    getHighScore();
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = yAxis;
    });
  }

  // Future<void> setHighScore() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     prefs.setInt(HIGH_SCORE_KEY, 0);
  //   });
  // }

  Future<void> getHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt(HIGH_SCORE_KEY) ?? 0;
    });
  }

  int getScore() {
    return (score / 2).round();
  }

  Future<void> showLoseDialog() async {
    await CoolAlert.show(
      context: context,
      type: CoolAlertType.info,
      title: 'Game Over',
      text: getScore() <= 0
          ? 'Good Luck Next Time 😂'
          : 'Your Score: ${getScore()} 😍😍',
      confirmBtnText: 'Retry',
      cancelBtnText: 'Home',
      confirmBtnColor: Colors.cyan,
      cancelBtnTextStyle:  TextStyle(
        color: Colors.green[900],
      ),
      showCancelBtn: true,
      barrierDismissible: false,
      animType: CoolAlertAnimType.slideInUp,
      backgroundColor: Colors.lightBlueAccent,
      onConfirmBtnTap: () {
        resetGame();
      },
      onCancelBtnTap: () {
        resetGame();
        Navigator.of(context).pop();
      },
    );
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      yAxis = 0;
      isStarted = false;
      initialHeight = yAxis;
      blockX = [0.7, 0.7 + 1.3, 0.7 + 2.6, 0.7 + 3.9, 0.7 + 5.2];
      time = 0;
      score = 0;
      getHighScore();
    });
  }

  void start() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isStarted = true;
    scoreTimer = Timer.periodic(
      const Duration(milliseconds: 3000),
      (timer) {
        if (isStarted) {
          setState(() {
            score++;
          });
        }
      },
    );
    Timer.periodic(const Duration(milliseconds: 20), (timer) async {
      height = gravity * time * time + velocity * time;
      setState(() {
        yAxis = initialHeight - height;
      });
      if (isIronManDead()) {
        timer.cancel();
        scoreTimer.cancel();
          if (getScore() > highScore) {
            highScore = getScore();
            await prefs.setInt(HIGH_SCORE_KEY, highScore);
          }
        showLoseDialog();
      }
      move();
      time += 0.01;
    });
  }

  void move() {
    for (int i = 0; i < blockX.length; i++) {
      // keep barriers moving
      setState(() {
        blockX[i] -= 0.005;
      });

      // if barrier exits the left part of the screen, keep it looping
      if (blockX[i] <= -1.5) {
        blockX[i] += 2.6;
      }
    }
  }

  bool isIronManDead() {
    if (yAxis > 1.1 || yAxis < -1.1) {
      return true;
    }
    for (int i = 0; i < blockX.length; i++) {
      if (blockX[i] <= manWidth &&
          blockX[i] + blockWidth >= -manWidth &&
          (yAxis <= -1 + blockHeight[i][0] ||
              yAxis + manHeight >= 1 - blockHeight[i][1])) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (isStarted) {
            jump();
          } else {
            start();
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  AnimatedContainer(
                    color: Colors.lightBlueAccent,
                    alignment: Alignment(0, yAxis),
                    duration: const Duration(milliseconds: 0),
                    child: IronManImg(
                      yAxis: yAxis,
                      manHeight: manHeight,
                      manWidth: manWidth,
                    ),
                  ),
                  Container(
                    alignment: const Alignment(0, 0.5),
                    child: isStarted
                        ? const Text("")
                        : const Text(
                            "TAP TO PLAY",
                            style: kSmallTextStyle,
                          ),
                  ),

                  Block(
                    blockX: blockX[0],
                    blockWidth: blockWidth,
                    blockHeight: blockHeight[0][0],
                    hasBottomBlock: false,
                  ),

                  // Bottom barrier 0
                  Block(
                    blockX: blockX[0],
                    blockWidth: blockWidth,
                    blockHeight: blockHeight[0][1],
                    hasBottomBlock: true,
                  ),

                  // Top barrier 1
                  Block(
                    blockX: blockX[1],
                    blockWidth: blockWidth,
                    blockHeight: blockHeight[1][0],
                    hasBottomBlock: false,
                  ),

                  // Bottom barrier 1
                  Block(
                    blockX: blockX[1],
                    blockWidth: blockWidth,
                    blockHeight: blockHeight[1][1],
                    hasBottomBlock: true,
                  ),

                  // Top barrier 2
                  Block(
                    blockX: blockX[2],
                    blockWidth: blockWidth,
                    blockHeight: blockHeight[2][0],
                    hasBottomBlock: false,
                  ),

                  // Bottom barrier 1
                  Block(
                    blockX: blockX[2],
                    blockWidth: blockWidth,
                    blockHeight: blockHeight[2][1],
                    hasBottomBlock: true,
                  ),

                  // Top barrier 1
                  Block(
                    blockX: blockX[3],
                    blockWidth: blockWidth,
                    blockHeight: blockHeight[3][0],
                    hasBottomBlock: false,
                  ),

                  // Bottom barrier 1
                  Block(
                    blockX: blockX[3],
                    blockWidth: blockWidth,
                    blockHeight: blockHeight[3][1],
                    hasBottomBlock: true,
                  ),

                  // Top barrier 1
                  Block(
                    blockX: blockX[4],
                    blockWidth: blockWidth,
                    blockHeight: blockHeight[4][0],
                    hasBottomBlock: false,
                  ),

                  // Bottom barrier 1
                  Block(
                    blockX: blockX[4],
                    blockWidth: blockWidth,
                    blockHeight: blockHeight[4][1],
                    hasBottomBlock: true,
                  ),
                ],
              ),
            ),
            Container(
              height: 10.0,
              color: Colors.green,
            ),
            Expanded(
                child: Container(
              color: Colors.brown,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("SCORE", style: kLabelTextStyle),
                          const SizedBox(height: 20.0),
                          Text(
                            "${getScore()}",
                            style: kLabelTextStyle,
                          )
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("YOUR BEST", style: kLabelTextStyle),
                          const SizedBox(height: 20.0),
                          Text(
                            "${highScore}",
                            style: kLabelTextStyle,
                          )
                        ]),
                  ]),
            ))
          ],
        ),
      ),
    );
  }
}
