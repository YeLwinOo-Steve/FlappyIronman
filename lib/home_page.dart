import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int highScore = 0;
  static const String HIGH_SCORE_KEY = 'highScore';
  @override
  void initState() {
    super.initState();
    getHighScore();
  }
  void getHighScore(){
    SharedPreferences.getInstance().then((prefs){
      setState(() {
        highScore = prefs.getInt(HIGH_SCORE_KEY) ?? 0;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    getHighScore();
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 50.0),
          const Center(
            child: Text(
            "Flappy Iron Man",
            style: TextStyle(
                fontFamily: 'Lily Script One',
                fontSize: 40.0,
                color: Colors.white),
          ),
          ),
          ClipOval(
            child: Image.asset(
              'assets/iron_man_dress_up.gif',
              width: size.width - 100.0,
              height: size.width - 100.0,
            ),
          ),
          Center(
            child: Text(
              "Your Best Score: $highScore",
              style:const TextStyle(
                color: Colors.black45,
                letterSpacing: 2.0,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context,"/play_game");
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 20.0
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 40.0),
                child: Column(
                  children: const [
                    Icon(
                      Icons.play_circle_outline,
                      size: 50.0,
                      color: Colors.lightBlue,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "PLAY",
                      style: TextStyle(
                          color: Colors.lightBlue,
                          letterSpacing: 3.0,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
