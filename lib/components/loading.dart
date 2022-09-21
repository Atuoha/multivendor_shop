import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
    required this.color,
    required this.kSize,
  }) : super(key: key);
  final Color color;
  final double kSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(
        color: color,
        size: kSize,
      ),
    );
  }
}
