import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'options_screen.dart';


class SinglePlayerPage extends StatefulWidget {
  @override
  SinglePlayerPageState createState() => SinglePlayerPageState();
}

class SinglePlayerPageState extends State<SinglePlayerPage> {
  Map<String, int> playerScores = {};
  List<String> board = List.filled(9, ''); // Initialize an empty 3x3 game board
  String currentPlayer = 'X'; // Start with player 'X'


  // Check if the game is over (someone wins or it's a draw)
  bool get isGameOver =>
      _checkWinner('X') || _checkWinner('O') || _isDraw();

  // Handle tap on a cell in the game grid
  void _handleTap(int index) {
    if (board[index].isEmpty && !isGameOver) {
      // If the cell is empty and the game is not over
      setState(() {
        board[index] = currentPlayer; // Update the cell with the current player's symbol
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X'; // Switch players
        if (currentPlayer == 'O' && !isGameOver) {
          // If it's AI's turn and the game is not over
          _handleAIMove(); // Make the AI move after a short delay
        }
      });
    }
  }

// Handle AI's move
void _handleAIMove() {
  if (!isGameOver) {
    int bestMove = _findBestMove();
    Future.delayed(Duration(milliseconds: 500), () {
      _handleTap(bestMove); // Make the AI move
    });
  }
}


// Find the best move for the AI
int _findBestMove() {
  // Check if the AI can win in the next move
  for (int i = 0; i < 9; i++) {
    if (board[i].isEmpty) {
      board[i] = 'O';
      if (_checkWinner('O')) {
        board[i] = ''; // Undo move
        return i;
      }
      board[i] = ''; // Undo move
    }
  }

// Find the index of the first empty cell on the board
int _getEmptyCellIndex() {
  List<int> emptyCells = [];
  for (int i = 0; i < board.length; i++) {
    if (board[i].isEmpty) {
      emptyCells.add(i);
    }
  }
  return emptyCells.isNotEmpty ? emptyCells[0] : -1;
}

  // Check if the player can win in the next move and block them
  for (int i = 0; i < 9; i++) {
    if (board[i].isEmpty) {
      board[i] = 'X';
      if (_checkWinner('X')) {
        board[i] = ''; // Undo move
        return i;
      }
      board[i] = ''; // Undo move
    }
  }

  // Try to take the center if it's available
  if (board[4].isEmpty) {
    return 4;
  }

  // Try to take a corner if available
  List<int> corners = [0, 2, 6, 8];
  for (int corner in corners) {
    if (board[corner].isEmpty) {
      return corner;
    }
  }

  // Take any available side
  for (int i = 1; i < 9; i += 2) {
    if (board[i].isEmpty) {
      return i;
    }
  }

  // Fallback: return the first empty cell
  return _getEmptyCellIndex();
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
bool _isDraw() {
  for (String cell in board) {
    if (cell.isEmpty) {
      return false;
    }
  }

  if (!_checkWinner('X') && !_checkWinner('O')) {
    // It's a draw
    if (playerScores.containsKey(currentPlayer)) {
      playerScores[currentPlayer] = playerScores[currentPlayer]! + 1;
    } else {
      playerScores[currentPlayer] = 1;
    }
    return true;
  }

  return false;
}


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double gridDimension = screenSize.width < screenSize.height
        ? screenSize.width * 0.8
        : screenSize.height * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TicTacToe - V.S Simple A.I'),
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
                  isGameOver
                      ? _checkWinner('X')
                          ? 'X Wins!'
                          : _checkWinner('O')
                              ? 'O Wins!'
                              : 'Game is a Draw!'
                      : 'Current Player: $currentPlayer',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
              onPressed: () {
                setState(() {
                  board = List.filled(9, ''); // Reset the game board
                  currentPlayer = 'X'; // Reset to player 'X'
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
