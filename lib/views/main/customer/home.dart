import 'package:flutter/material.dart';
import '../../../components/home_carousel.dart';
import '../product_categories/children.dart';
import '../product_categories/men.dart';
import '../product_categories/others.dart';
import '../product_categories/sneakers.dart';
import '../product_categories/women.dart';
import '../../../components/search_box.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentTabIndex = 0;
  var categories = [
    'Men',
    'Women',
    'Children',
    'Sneakers',
    'Others',
  ];

  final categoriesList = const [
    MenWears(),
    WomenWears(),
    ChildrenWears(),
    Sneakers(),
    Others(),
  ];

  Widget kText(String text, int index) {
    return GestureDetector(
      onTap: () => setState(() {
        currentTabIndex = index;
      }),
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: Text(
          text,
          style: TextStyle(
            color: currentTabIndex == index ? Colors.black : Colors.grey,
            fontSize: currentTabIndex == index ? 27 : 18,
            fontWeight:
            currentTabIndex == index ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              child: const SearchBox(),
            ),
           
            const SizedBox(height: 10),
            buildCarouselSlider(),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) =>
                    kText(categories[index], index),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1,
              child: Column(
                children: [
                  categoriesList[currentTabIndex],
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Other Contents can come in.....')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
