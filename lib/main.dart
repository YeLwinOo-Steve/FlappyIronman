// @dart=2.9

import 'package:flappy_ironman/home_page.dart';
import 'package:flappy_ironman/play_game.dart';
import 'package:flutter/material.dart';

import 'loading_page.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/play_game": (context) => PlayGame(),
        "/home_page": (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
      home: LoadingPage(),
    );
  }
}

