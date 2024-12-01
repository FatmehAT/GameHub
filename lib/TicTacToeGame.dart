import 'package:flutter/material.dart';
import 'gameOverTicTacToe.dart';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  String player = 'X';
  List<String> board = List.filled(9, '');
  String winner = '';

  @override
  Widget build(BuildContext context) {
    String text;
    if (winner.isEmpty) {
      text = 'Current Player: $player';
    } else if (winner == 'Draw') {
      text = 'It\'s a Draw!';
    } else {
      text = 'Winner: $winner';
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Tic Tac Toe"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 390,
              height: 400,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => play(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.grey[300],
                      ),
                      child: Center(
                        child: Text(
                          board[index],
                          style: TextStyle(
                            fontSize: 100,
                            color: color(board[index]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkWinner() {
    List<List<int>> conditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], //rows
      [0, 3, 6],
      [
        1,
        4,
        7,
      ],
      [2, 5, 8], //columns
      [0, 4, 8], [2, 4, 6] //diagonals
    ];
    for (int i = 0; i < conditions.length; i++) {
      List<int> condition = conditions[i];
      if (board[condition[0]] == player &&
          board[condition[1]] == player &&
          board[condition[2]] == player) {
        setState(() {
          winner = player;
          gameOver();
          return;
        });
      }
    }
    if (!board.contains('') && winner == '') {
      setState(() {
        winner = 'Draw';
        gameOver();
      });
    }
  }

  void play(int index) {
    if (board[index] == '' && winner == '') {
      setState(() {
        board[index] = player;
        checkWinner();
        if (player == 'X') {
          player = 'O';
        } else {
          player = 'X';
        }
      });
    }
  }

  Color color(String player) {
    if (player == 'X') {
      return Colors.teal;
    } else if (player == 'O') {
      return Colors.amberAccent;
    } else {
      return Colors.black;
    }
  }

  void gameOver() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameOverTicTacToe(
          winner: winner,
        ),
      ),
    );
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      player = 'X';
      winner = '';
    });
  }
}
