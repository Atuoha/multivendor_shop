import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.color}) : super(key: key);
  final Color color;
  final double _kSize = 100;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(
        color: color,
        size: _kSize,
      ),
    );
  }
}
