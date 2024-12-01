import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'gameOverSnake.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int rows = 20;
  static const int columns = 20;
  Set<int> snakePositions = {42, 43, 44};
  int? head;
  int food = 30;
  int score = 0;
  String? currentDirection;
  Timer? timer;
  Random r = Random();

  @override
  void initState() {
    super.initState();
    _food();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startMoving() {
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (currentDirection != null) {
        moveSnake(currentDirection!);
      }
    });
  }

  void _food() {
    do {
      food = r.nextInt(rows * columns);
    } while (snakePositions.contains(food));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Snake Game"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: 1.0,
              ),
              itemCount: rows * columns,
              itemBuilder: (context, index) {
                head = snakePositions.last;
                return Container(
                  margin: const EdgeInsets.all(1),
                  color: () {
                    if (index == head) {
                      return Colors.red;
                    } else if (snakePositions.contains(index)) {
                      return Colors.teal;
                    } else if (index == food) {
                      return Colors.yellow;
                    } else {
                      return Colors.grey.shade300;
                    }
                  }(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                arrowButton(
                  icon: Icons.keyboard_arrow_up,
                  onPressed: () => _changeDirection('up'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    arrowButton(
                      icon: Icons.keyboard_arrow_left,
                      onPressed: () => _changeDirection('left'),
                    ),
                    arrowButton(
                      icon: Icons.keyboard_arrow_right,
                      onPressed: () => _changeDirection('right'),
                    ),
                  ],
                ),
                arrowButton(
                  icon: Icons.keyboard_arrow_down,
                  onPressed: () => _changeDirection('down'),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            width: 150,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.teal,
            ),
            alignment: Alignment.bottomCenter,
            child: Text(
              "Score: $score",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _changeDirection(String newDirection) {
    if ((currentDirection == 'up' && newDirection == 'down') ||
        (currentDirection == 'down' && newDirection == 'up') ||
        (currentDirection == 'left' && newDirection == 'right') ||
        (currentDirection == 'right' && newDirection == 'left')) {
      return;
    }
    if (timer == null) {
      _startMoving();
    }

    currentDirection = newDirection;
  }

  int updateScore(int score) {
    return score++;
  }

  void moveSnake(String direction) {
    setState(() {
      head = snakePositions.last;
      int newHead;
      if (direction == 'up') {
        newHead = head! - columns;
      } else if (direction == 'down') {
        newHead = head! + columns;
      } else if (direction == 'left') {
        newHead = head! - 1;
      } else if (direction == 'right') {
        newHead = head! + 1;
      } else {
        newHead = head!;
      }

      if (newHead < 0 ||
          newHead >= rows * columns ||
          (direction == 'left' && head! % columns == 0) ||
          (direction == 'right' && head! % columns == columns - 1)) {
        timer?.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameOverSnake(
              score: score,
            ),
          ),
        );
        snakePositions = {42, 43, 44};
        currentDirection = null;
        return;
      }
      if (newHead == food) {
        snakePositions.add(newHead);
        _food();
        score++;
      } else {
        snakePositions.add(newHead);
        snakePositions.remove(snakePositions.first);
      }
    });
  }
}

Widget arrowButton({required IconData icon, required VoidCallback onPressed}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.teal,
      borderRadius: BorderRadius.circular(8),
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
    ),
  );
}
