// main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_page.dart';
import 'options_screen.dart';
import 'high_scores.dart';
import 'Single_Player.dart'; // Import the SinglePlayerPage

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              'assets/logos/TicTacToeIcon.png',
              width: 300,
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to SinglePlayerPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SinglePlayerPage()),
                  );
                },
                child: const Text('Single Player Game'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GamePage()),
                  );
                },
                child: const Text('2 Player Game'),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OptionsScreen()),
                  );
                },
                child: const Text('          Options          '),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HighScores()),
                  );
                },
                child: const Text('      High Scores      '),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('             Exit             '),
              ),
             ),
          ],
        ),
      ),
    );
  }
}