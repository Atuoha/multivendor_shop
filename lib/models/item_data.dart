import 'package:flutter/material.dart';

class ItemData {
  final Color color;
  final String image;
  final String title;
  final String content;
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final Color btnColor;

  ItemData(
    this.color,
    this.image,
    this.title,
    this.content,
    this.contentStyle,
    this.titleStyle,
      this.btnColor,
  );
}
