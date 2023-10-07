import 'package:flutter/material.dart';

const kOptionButtonTextStyle = TextStyle(color: Colors.white);

const kOptionContainerStyle = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF3b6da8),
      Color(0xFF224c96),
    ],
    stops: [
      0.1,
      0.9,
    ],
  ),
  borderRadius: BorderRadius.all(
    Radius.circular(25.0),
  ),
);
