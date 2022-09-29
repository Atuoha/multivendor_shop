import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class MenWears extends StatelessWidget {
  const MenWears({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        const Text(
          'For Men',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: size.height * 0.73,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            children: List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal:10.0),
                child: Container(
                  color: primaryColor,
                  height: 60,
                  width: 60,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
