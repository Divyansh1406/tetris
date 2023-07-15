import 'dart:ui';

import 'package:tetris/gameboard.dart';

import 'values.dart';

class Piece {
  Tetro type;

  Piece({required this.type});

  //the piece is list of integers

  List<int> position = [];

  //color of piece
  Color get color {
    return tetroColors[type] ?? const Color(0xFFFFFFFF);
  }

  //generate the integers
  void initializePiece() {
    switch (type) {
      case Tetro.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetro.J:
        position = [-25, -15, -5, -6];
        break;
      case Tetro.I:
        position = [-4, -5, -6, -7];
        break;
      case Tetro.O:
        position = [-15, -16, -5, -6];
        break;
      case Tetro.S:
        position = [-15, -14, -6, -5];
        break;
      case Tetro.Z:
        position = [-17, -16, -6, -5];
        break;
      case Tetro.T:
        position = [-26, -16, -6, -15];
        break;
      default:
    }
  }

  //move piece
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case Direction.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }

  //rotate piece
  int rotationState = 1;
  List<int> newPosition = [];

  void rotatePiece() {
    //new position=[position[1]-rowlen,[1],position[1]+rowlen,position[1]+rowlen+1]
    switch (type) {
      case Tetro.L:
        switch (rotationState) {
          case 0:
            //get new position
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1,
            ];

            //check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }

            break;
          case 1:
            //get new position
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
            ];
            //check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }

            break;
          case 2:
            //get new position
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1,
            ];
            //check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = (rotationState + 1) % 4;
            }

            break;
          case 3:
            //get new position
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            //check that this new position is a valid move before assigning it to the real position
            if (piecePositionIsValid(newPosition)) {
              //update position
              position = newPosition;
              //update rotation state
              rotationState = 0;
            }

            break;
        }
      case Tetro.I:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;

          case 3:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - 2 * rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = 0;
            }
            break;
        }
        break;

      case Tetro.Z:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[0] + rowLength - 2,
              position[1] ,
              position[2] + rowLength -1,
              position[3] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength+1,
              position[3] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength-1,
              position[3] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength+1,
              position[3] - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = 0;
            }
            break;
        }
        break;

      case Tetro.S:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] ,
              position[1] + 1,
              position[1] + rowLength-1,
              position[1] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1],
              position[1]+1,
              position[1] + rowLength-1,
              position[1] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[0]-rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength+1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = 0;
            }
            break;
        }
        break;

      case Tetro.O:
        // O shape does not rotate
        break;

      case Tetro.J:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - rowLength - 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowLength + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = 0;
            }
            break;
        }
        break;

      case Tetro.T:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[2] - rowLength,
              position[2],
              position[2]+1,
              position[2] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] - rowLength,
              position[1] - 1,
              position[1],
              position[1] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[2] - rowLength,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = 0;
            }
            break;
        }
        break;

      default:
        break;
    }
  }

  //check if valid position
  bool positionIsValid(int position) {
    //get the row and col of position
    int row = (position / rowLength).floor();
    int col = position % rowLength;

    //if the position is taken,return false
    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    }
    //otherwise position is valid so return true
    else {
      return true;
    }
  }

  //check if piece is valid position
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePosition) {
      //return false if any position is already taken
      if (!positionIsValid(pos)) {
        return false;
      }
      //get the col of position
      int col = pos % rowLength;

      //check if the first or last column is occupied
      if (col == 0) {
        firstColOccupied = true;
      }
      if (col == rowLength - 1) {
        lastColOccupied = true;
      }
    }

    //if there is a piece in the first col and last col,it is going through the wall
    return !(firstColOccupied && lastColOccupied);
  }
}
