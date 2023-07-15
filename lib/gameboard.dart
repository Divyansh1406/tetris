import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/values.dart';
/*
2x2 grid with null representing an empty space
a non empty space will have the color to represent landed pieces
 */

//create game board
List<List<Tetro?>> gameBoard = List.generate(
    colLength,
    (i) => List.generate(
          rowLength,
          (j) => null,
        ));

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //current tetris piece
  Piece currentPiece = Piece(type: Tetro.L);

  //current score=0;
  int currentScore = 0;

  bool gameOver = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    Duration frameRate = const Duration(milliseconds: 550);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        //clear lines
        clearLines();

        //check landing
        checkLanding();

        //check if game is over
        if (gameOver == true) {
          timer.cancel();
          showGameOverDialog();
        }

        //move piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  //game over message
  void showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Game Over"),
          content: Text("Your score is: $currentScore"),
          actions: [
            TextButton(
                onPressed: () {
                  resetGame();
                  Navigator.pop(context);
                },
                child: Text("Play Again"))
          ],
        ));
  }

  //reset game
  void resetGame() {
    //clear the game board
    gameBoard =
        List.generate(colLength, (i) => List.generate(rowLength, (j) => null));

    //new game
    gameOver = false;
    currentScore = 0;

    createNewPiece();
    startGame();
  }

  //check for collision detection
  //return true if collision
  bool checkCollision(Direction direction) {
    //loop through each position of each piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      //calculate row and col of the current position
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      //adjust the row and col based on the direction
      if (direction == Direction.left) {
        col = col - 1;
      } else if (direction == Direction.right) {
        col = col + 1;
      } else if (direction == Direction.down) {
        row = row + 1;
      }

      //check if the piece is out of bounds(either too low or too far to the left or right)
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      } else if (col >= 0 && row > 0 && gameBoard[row][col] != null) {
        return true;
      }
    }
    //no collision
    return false;
  }

  void checkLanding() {
    //if going down is occupied
    if (checkCollision(Direction.down)) {
      //mark position as occupied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      //once landed create new piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    //create a random object to generate random tetro types
    Random rand = Random();

    //create a new piece with random type
    Tetro randomType = Tetro.values[rand.nextInt(Tetro.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    //instead of checking every frame,check when new piece is made

    if (isGameOver()) {
      gameOver = true;
    }
  }

  //move left
  void moveLeft() {
    //make sure the move is valid before moving there
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  //move right
  void moveRight() {
    //make sure the move is valid before moving there
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  //rotate piece
  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  //clear lines
  void clearLines() {
    //1. loop through each row of the game board from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      //2. initialize a variable to track if row is full
      bool rowIsFull = true;
      //3. check if the row is full(all col in the row are filled with pieces)
      for (int col = 0; col < rowLength; col++) {
        //if there's an empty column,set rowIsFull to false and break loop
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }
      //4. clear the row if it is full and shift rows down
      if (rowIsFull) {
        //step 5: move all rows above the cleared row down by one position
        for (int r = row; r > 0; r--) {
          //copy the above row to current row
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        //6.set top row to empty
        gameBoard[0] = List.generate(row, (index) => null);
        //7.add +1 to score
        currentScore++;
      }
    }
  }

  //game over method
  bool isGameOver() {
    //check if any columns in top row are filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    //if top row is empty,the game is not over
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rowLength * colLength,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLength),
                itemBuilder: (context, index) {
                  //get row and col of each index
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;
                  //current piece
                  if (currentPiece.position.contains(index)) {
                    return Pixel(
                      color: currentPiece.color,
                    );
                  }
                  //landed pieces
                  else if (gameBoard[row][col] != null) {
                    final Tetro? tertoType = gameBoard[row][col];
                    final color = tetroColors[tertoType];
                    return Pixel(color: color ?? Color(0xFFFFFFFF));
                  }
                  //empty pixel
                  else {
                    return Pixel(
                      color: Colors.white12,
                    );
                  }
                }),
          ),
          //score
          Text(
            'Score: $currentScore',
            style: TextStyle(color: Colors.white),
          ),

          //controls
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //left
                IconButton(
                  onPressed: moveLeft,
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                ),
                //rotate
                IconButton(
                  onPressed: rotatePiece,
                  icon: Icon(Icons.rotate_right),
                  color: Colors.white,
                ),

                //right
                IconButton(
                  onPressed: moveRight,
                  icon: Icon(Icons.arrow_forward),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
      //Game Controls
    );
  }
}
