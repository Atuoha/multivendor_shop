import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class SneakersCategories extends StatelessWidget {
  const SneakersCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
          child: GridView.builder(
            itemCount: categories.length,
            padding: const EdgeInsets.only(top: 5),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
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
                              'assets/images/sub_categories/sneakers/${categories[index].toLowerCase()}.jpg',
                            ),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    const  SizedBox(height: 2),
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 2,
            ),
          ),
        ),
      ],
    );
  }
}
