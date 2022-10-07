import 'package:flutter/material.dart';
import '../../../utilities/category_gridview.dart';

class SneakersCategories extends StatelessWidget {
  const SneakersCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var imageLocation = 'assets/images/sub_categories/sneakers/';
    var category = 'Sneakers';

    final categories = [
      'Adidas',
      'Fila',
      'Nike',
      'Reebok',
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            'Sneakers categories',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: size.height * 0.73,
          child: CategoryGridView(
            categories: categories,
            category: category,
            imageLocation: imageLocation,
          ),
        ),
      ],
    );
  }
}
