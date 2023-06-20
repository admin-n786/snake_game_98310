import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  // Game state variables
  List<int> snakePosition = [45, 65, 85, 105];
  int numberOfSquaresPerRow = 20;
   int? foodIndex;
  var direction = 'right';
  bool gameOver = false;
  var random = Random();
  int score = 0;

  @override
  Widget build(BuildContext context) {
    if (gameOver) {
      return GestureDetector(
        onTap: () {
          setState(() {
            snakePosition = [45, 65, 85, 105];
            direction = 'right';
            gameOver = false;
            score = 0;
            generateFood();
          });
        },
        child: buildGameOverMessage(),
      );
    }

    // Draw board and snake
    List<Widget> boardRows = [];
    for (int i = 0; i < numberOfSquaresPerRow; i++) {
      List<Widget> rowSquares = [];
      for (int j = 0; j < numberOfSquaresPerRow; j++) {
        rowSquares.add(
          buildGameBoard()[i * numberOfSquaresPerRow + j],
        );
      }
      boardRows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowSquares,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Snake Game'),
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: onKeyPressed,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: boardRows,
          ),
        ),
      ),
    );
  }


  void generateFood() {
    foodIndex = random.nextInt(numberOfSquaresPerRow * numberOfSquaresPerRow);
  }

  void moveSnake() {
    setState(() {
      switch (direction) {
        case 'up':
          if (!snakePosition.contains(snakePosition.first - numberOfSquaresPerRow)) {
            snakePosition.insert(0, snakePosition.first - numberOfSquaresPerRow);
          } else {
            gameOver = true;
          }
          break;
        case 'down':
          if (!snakePosition.contains(snakePosition.first + numberOfSquaresPerRow)) {
            snakePosition.insert(0, snakePosition.first + numberOfSquaresPerRow);
          } else {
            gameOver = true;
          }
          break;
        case 'left':
          if (!snakePosition.contains(snakePosition.first - 1) && (snakePosition.first % numberOfSquaresPerRow != 0)) {
            snakePosition.insert(0, snakePosition.first - 1);
          } else {
            gameOver = true;
          }
          break;
        case 'right':
          if (!snakePosition.contains(snakePosition.first + 1) && ((snakePosition.first + 1) % numberOfSquaresPerRow != 0)) {
            snakePosition.insert(0, snakePosition.first + 1);
          } else {
            gameOver = true;
          }
          break;
      }

      // If the snake eats the food
      if (snakePosition.first == foodIndex) {
        score++;
        generateFood();
      } else {
        snakePosition.removeLast();
      }
    });
  }

  void onKeyPressed(RawKeyEvent event) {
    setState(() {
      if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
        direction = 'up';
      } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
        direction = 'down';
      } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
        direction = 'left';
      } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
        direction = 'right';
      }
    });
  }

  List<Widget> buildGameBoard() {
    List<Widget> boardSquares = [];

    for (int i = 0; i < numberOfSquaresPerRow * numberOfSquaresPerRow; i++) {
      // Board squares
      boardSquares.add(
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            border:
            Border.all(
              color: Colors.grey,
            ),
          ),
        ),
      );

      // Snake
      if (snakePosition.contains(i)) {
        boardSquares[i] = Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(
              color: Colors.grey,
            ),
          ),
        );
      }

      // Food
      if (i == foodIndex) {
        boardSquares[i] = Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.red,
            border: Border.all(
              color: Colors.grey,
            ),
          ),
        );
      }
    }

    return boardSquares;
  }

  Widget buildGameOverMessage() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Game Over!\nScore: $score\nTap to play again',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
      color: Colors.black.withOpacity(0.5),
    );
  }
}










