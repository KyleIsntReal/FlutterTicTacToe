import 'package:flutter/material.dart';
import 'Name_input_screen.dart'; // Import the new screen

import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => NameInputScreen())); // Navigate to the NameInputScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logos/TicTacToeIcon.png'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
