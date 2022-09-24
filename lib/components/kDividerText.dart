import 'package:flutter/material.dart';

import '../constants/colors.dart';

class KDividerText extends StatelessWidget {
  const KDividerText({
    Key? key,
    required this.title,

  }) : super(key: key);
  final String title;


  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
         const  SizedBox(
            width: 50,
            child: Divider(
              thickness: 2,
              color: primaryColor,
            ),
          ),
          Text(
            title,
            style:const  TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
         const  SizedBox(
            width: 50,
            child: Divider(
              thickness: 2,
              color: primaryColor
            ),
          ),
        ],
      ),
      const SizedBox(height: 5),
    ],);
  }
}
