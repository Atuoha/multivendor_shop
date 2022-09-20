import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class CustomerLandingScreen extends StatelessWidget {
  const CustomerLandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget kContainer(
      IconData icon,
    ) {
      return Container(
        height: 50,
        width: 50,
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Icon(
            icon,
          ),
        ),
      );
    }

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Create Customer Account'),
            Icon(Icons.person, color: primaryColor),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: primaryColor,
              child: Center(
                child: Icon(
                  Icons.image_sharp,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.photo,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt_rounded,
                    ),
                  ),
                )
              ],
            )
          ],
        )
      ],
    ));
  }
}
