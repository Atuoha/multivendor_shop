import 'package:flutter/material.dart';
import 'package:multivendor_shop/constants/colors.dart';
import 'product_categories/children.dart';
import 'product_categories/men.dart';
import 'product_categories/others.dart';
import 'product_categories/sneakers.dart';
import 'product_categories/women.dart';
import '../../../components/search_box.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentTabIndex = 0;

  var slides = [
    'assets/images/slides/slide_1.jpg',
    'assets/images/slides/slide_2.jpg',
    'assets/images/slides/slide_4.jpg',
    'assets/images/slides/slide_3.jpg',
    'assets/images/slides/slide_5.jpg',
    'assets/images/slides/slide_6.jpg',
    'assets/images/slides/slide_7.jpg',
    'assets/images/slides/slide_8.jpg',
    'assets/images/slides/slide_9.jpg',
    'assets/images/slides/slide_10.jpg',
    'assets/images/slides/slide_11.jpg',
    'assets/images/slides/slide_12.jpg',
    'assets/images/slides/slide_13.jpg',
    'assets/images/slides/slide_14.jpg',
  ];

  var categories = ['Men', 'Women', 'Children', 'Sneakers', 'Others'];

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
            fontSize: currentTabIndex == index ? 37 : 28,
            fontWeight:
                currentTabIndex == index ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget kSlideContainer(String imgUrl) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imgUrl,
          fit: BoxFit.cover,
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
            const SizedBox(height: 20),
            CarouselSlider.builder(
              options: CarouselOptions(
                viewportFraction: 0.7,
                aspectRatio: 2.0,
                height: 250,
                enlargeStrategy: CenterPageEnlargeStrategy.scale,
                enlargeCenterPage: true,
                autoPlay: true,
              ),
              itemCount: slides.length,
              itemBuilder: (context, index, i) =>
                  kSlideContainer(slides[index]),
            ),
            const SizedBox(height: 15),
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
                 const  SizedBox(height: 10,),
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
