import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 48.0, right: 18, left: 18),
      child: Column(
        children: [
          Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                Icon(
                  Icons.dashboard,
                  color: primaryColor,
                ),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
              height: size.height / 1.25,
              child: GridView.count(
                padding: EdgeInsets.zero,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 25,
                children: List.generate(
                  6,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: litePrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.storefront,
                          size: 65,
                          color: primaryColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Store',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
