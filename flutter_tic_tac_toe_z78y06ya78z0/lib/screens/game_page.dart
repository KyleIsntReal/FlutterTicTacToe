import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'options_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  List<String> board = List.filled(9, ''); // Initialize an empty 3x3 game board
  String currentPlayer = 'X'; // Start with player 'X'
  String statusMessage = 'Current Player: X';
  int playerXScore = 0; // Player X's score
  int playerOScore = 0; // Player O's score

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  // Function to handle a tap
  void _handleTap(int index) {
    if (board[index] != '' || _checkWinner('X') || _checkWinner('O')) return;
    setState(() {
      board[index] = currentPlayer;
      if (_checkWinner(currentPlayer)) {
        // Player wins
        statusMessage = '$currentPlayer Wins!';
        _updateScores();

        // Delay before starting a new game
        Future.delayed(Duration(milliseconds: 500), () {
          _startNewGame();
        });
      } else if (_isDraw()) {
        // Game is a draw
        statusMessage = 'Game is a Draw!';

        // Delay before starting a new game
        Future.delayed(Duration(milliseconds: 500), () {
          _startNewGame();
        });
      } else {
        // Switch player
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        statusMessage = 'Current Player: $currentPlayer';
      }
    });
  }

  // Update player scores based on the winner
  void _updateScores() {
    if (_checkWinner('X')) {
      playerXScore++;
    } else if (_checkWinner('O')) {
      playerOScore++;
    }
    _saveScores(); // Save scores when they are updated
  }

  // Check if there is a winner for the specified player
  bool _checkWinner(String player) {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (board[i] == player && board[i + 1] == player && board[i + 2] == player) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[i] == player && board[i + 3] == player && board[i + 6] == player) {
        return true;
      }
    }

    // Check diagonals
    if (board[0] == player && board[4] == player && board[8] == player) {
      return true;
    }
    if (board[2] == player && board[4] == player && board[6] == player) {
      return true;
    }

    return false;
  }

  // Check if the game is a draw
  bool _isDraw() {
    for (String cell in board) {
      if (cell.isEmpty) {
        return false;
      }
    }

    return !_checkWinner('X') && !_checkWinner('O');
  }

  // Reset the game board
  void _startNewGame() {
    setState(() {
      board = List.filled(9, ''); // Create a new instance of the game board
      currentPlayer = 'X'; // Reset to player 'X'
      statusMessage = 'Current Player: $currentPlayer';
    });
  }

  // Save scores using shared preferences
  void _saveScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('playerXScore', playerXScore);
    prefs.setInt('playerOScore', playerOScore);
  }

  // Load scores using shared preferences
  void _loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      playerXScore = prefs.getInt('playerXScore') ?? 0;
      playerOScore = prefs.getInt('playerOScore') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // Calculate the width and height based on the percentage
    double gridDimension = screenSize.width < screenSize.height
        ? screenSize.width * 0.8 // Portrait or square - base on width
        : screenSize.height * 0.8; // Landscape - base on height

    return Scaffold(
      appBar: AppBar(
        title: const Text('StarWars TicTacToe'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: gridDimension,
            maxHeight: gridDimension,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(3.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => _handleTap(index),
                      child: GridTile(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Center(
                            child: board[index].isEmpty
                                ? null
                                : Image.asset(
                                    'assets/icons/${board[index]}.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$statusMessage\nPlayer X Score: $playerXScore\nPlayer O Score: $playerOScore',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OptionsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _startNewGame, // Reset the game
            ),
          ],
        ),
      ),
    );
  }
}