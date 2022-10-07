import 'package:flutter/material.dart';
import '../../../utilities/category_gridview.dart';

class ChildrenCategories extends StatelessWidget {
  const ChildrenCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var imageLocation = 'assets/images/sub_categories/children/';
    var category = 'Children';

    final categories = [
      'Jeans',
      'Inner',
      'Jacket',
      'Cardigan',
      'Joggers',
      'T-shirt',
      'Gown',
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            'Categories for children',
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
