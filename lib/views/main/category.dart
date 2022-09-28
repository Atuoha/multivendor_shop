import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'product_categories/children.dart';
import 'product_categories/men.dart';
import 'product_categories/others.dart';
import 'product_categories/sneakers.dart';
import 'product_categories/women.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var currentCategory = 0;
  var categories = [
    {'title': 'Men', 'img': 'assets/images/category_imgs/men.png'},
    {'title': 'Women', 'img': 'assets/images/category_imgs/women.png'},
    {'title': 'Children', 'img': 'assets/images/category_imgs/children.png'},
    {'title': 'Sneakers', 'img': 'assets/images/category_imgs/sneakers.png'},
    {'title': 'Others', 'img': 'assets/images/category_imgs/other.png'}
  ];

  final categoriesList = const [
    MenWears(),
    WomenWears(),
    ChildrenWears(),
    Sneakers(),
    Others(),
  ];


  Widget kCategoryContainer(
    String text,
    String imgUrl,
    int index,
  ) {
    return GestureDetector(
      onTap: () => setState(() {
        currentCategory = index;
      }),
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.all(10),
          // height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: currentCategory == index ? Colors.white : Colors.transparent,
          ),
          child: Column(
            children: [
              Image.asset(
                imgUrl,

                fit: BoxFit.cover,
              ),
              const SizedBox(height: 5),
              Text(
                text,
                style: TextStyle(
                  fontWeight: currentCategory == index
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              )
            ],
          )),
    );
  }

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
                child: categoriesList[currentCategory]
              ),
              Container(
                width: size.width / 5,
                height: size.height * 0.83,
                decoration: BoxDecoration(
                  color: litePrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  itemCount: categories.length,
                  itemBuilder: (context, index) => kCategoryContainer(
                    categories[index]['title']!,
                    categories[index]['img']!,
                    index,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
