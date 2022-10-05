import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';

class WomenWears extends StatelessWidget {
  const WomenWears({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            'Products for women',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: size.height * 0.73,
          child: GridView.count(
            padding: const EdgeInsets.only(top: 5),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: List.generate(
              50,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor,
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                            'assets/images/products/women/10_1.jpg'),
                      ),
                      const Positioned(
                        bottom: 2,
                        left: 5,
                        child: Text(
                          'Cloth',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
