import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 48.0),
      child: Column(
        children: [
          Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                Icon(
                  Icons.category,
                  color: primaryColor,
                ),
                Text(
                  'Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: size.width / 1.25,
                height: size.height * 0.83,
              ),
              Container(
                width: size.width / 5,
                height: size.height * 0.83,
                decoration: BoxDecoration(
                  color: litePrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
