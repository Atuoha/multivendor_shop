import 'package:flutter/material.dart';
import 'package:multivendor_shop/constants/colors.dart';
import '../../components/search_box.dart';
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
    'assets/images/slides/slide_3.jpg',
    'assets/images/slides/slide_11.jpg',
    'assets/images/slides/slide_12.jpg',
    'assets/images/slides/slide_13.jpg',
    'assets/images/slides/slide_14.jpg',
    'assets/images/slides/slide_3.jpg',
    'assets/images/slides/slide_4.jpg',
    'assets/images/slides/slide_5.jpg',
    'assets/images/slides/slide_6.jpg',
    'assets/images/slides/slide_7.jpg',
    'assets/images/slides/slide_8.jpg',
    'assets/images/slides/slide_9.jpg',
    'assets/images/slides/slide_10.jpg',
  ];

  var categories = [
    'Men',
    'Women',
    'Children',
    'Other',
  ];

  Widget kText(String text, int index) {
    return GestureDetector(
      onTap: () => setState(() {
        currentTabIndex = index;
      }),
      child: Text(
        text,
        style: TextStyle(
          color: currentTabIndex == index ? Colors.black : Colors.grey,
          fontSize: currentTabIndex == index ? 28 : 22,
        ),
      ),
    );
  }

  Widget kSlideContainer(String imgUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        imgUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
      ),
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
              height: 300,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
              enlargeCenterPage: true,
              autoPlay: true,
            ),
            itemCount: slides.length,
            itemBuilder: (context, index, i) => kSlideContainer(slides[index]),
          ),
          const SizedBox(height: 10),
          Container(
            height: 50,
            color: Colors.red,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => kText(categories[index], index),
            ),
          )
        ],
      ),
    );
  }
}
