import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../models/category.dart';
import '../categories/children.dart';
import '../categories/men.dart';
import '../categories/other.dart';
import '../categories/sneakers.dart';
import '../categories/women.dart';


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _pageController = PageController();

  final List<CategoryItem> categories = [
    CategoryItem(
      title: 'Men',
      imgUrl: 'assets/images/category_imgs/men.png',
      isActive: true,
    ),
    CategoryItem(
      title: 'Women',
      imgUrl: 'assets/images/category_imgs/women.png',
    ),
    CategoryItem(
      title: 'Children',
      imgUrl: 'assets/images/category_imgs/children.png',
    ),
    CategoryItem(
      title: 'Sneakers',
      imgUrl: 'assets/images/category_imgs/sneakers.png',
    ),
    CategoryItem(
      title: 'Others',
      imgUrl: 'assets/images/category_imgs/other.png',
    )
  ];

  final categoriesList = const [
    MenCategories(),
    WomenCategories(),
    ChildrenCategories(),
    SneakersCategories(),
    OtherCategories(),
  ];

  Widget kCategoryContainer(
    CategoryItem category,
    int index,
  ) {
    return GestureDetector(
      onTap: () => setState(() {
        _pageController.jumpToPage(index);
      }),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        // height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: category.isActive ? Colors.white : Colors.transparent,
        ),
        child: Column(
          children: [
            Image.asset(
              category.imgUrl,
              color: category.isActive ? primaryColor : Colors.black,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 5),
            Text(
              category.title,
              style: TextStyle(
                fontWeight:
                    category.isActive ? FontWeight.w600 : FontWeight.w500,
                color: category.isActive ? primaryColor : Colors.black,
              ),
            )
          ],
        ),
      ),
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
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (value) {
                    setState(() {
                      for (var catItem in categories) {
                        catItem.setActive(false);
                      }
                      categories[value].setActive(true);
                    });
                  },
                  children: categoriesList,
                ),
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
                  itemBuilder: (context, index) =>
                      kCategoryContainer(categories[index], index),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
