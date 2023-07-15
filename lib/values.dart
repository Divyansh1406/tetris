import 'dart:ui';

import 'package:flutter/material.dart';

int rowLength = 10;
int colLength = 15;

enum Direction
{
  left,
  right,
  down,
}

enum Tetro
{
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

const Map<Tetro,Color> tetroColors={
  Tetro.L:Color(0xFFFFA500),
  Tetro.J:Color(0xFF002BFF),
  Tetro.I:Color(0xFF2CEF00),
  Tetro.O:Color(0xFFFF0046),
  Tetro.S:Color(0xFFFFEA00),
  Tetro.Z:Color(0xFF00FFA9),
  Tetro.T:Color(0xFFFF00EA),
};