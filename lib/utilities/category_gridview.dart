import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../views/main/product/sub_category_products.dart';

class CategoryGridView extends StatelessWidget {
  const CategoryGridView({
    Key? key,
    required this.categories,
    required this.category,
    required this.imageLocation,
  }) : super(key: key);

  final List<String> categories;
  final String category;
  final String imageLocation;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: categories.length,
      padding: const EdgeInsets.only(top: 5),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SubCategoryScreen(
                category: category,
                subCategory: categories[index],
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: primaryColor,
            ),
            child: Column(
              children: [
                Container(
                  height: 115,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetImage(
                          '$imageLocation${categories[index].toLowerCase()}.jpg',
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  categories[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: 2,
      ),
    );
  }
}
