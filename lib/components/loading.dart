import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);
  final double _kSize = 100;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(
        color: Colors.white,
        size: _kSize,
      ),
    );
  }
}
