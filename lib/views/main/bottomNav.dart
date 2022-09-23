import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:multivendor_shop/constants/colors.dart';
import 'package:multivendor_shop/views/main/cart.dart';
import 'package:multivendor_shop/views/main/home.dart';
import 'package:multivendor_shop/views/main/profile.dart';
import 'package:multivendor_shop/views/main/search.dart';
import 'package:multivendor_shop/views/main/shop.dart';

class BottomNav extends StatefulWidget {
  static const routeName = '/home';

  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var currentPageIndex = 0;
  final _pages = const [
    HomeScreen(),
    SearchScreen(),
    ShopScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  selectPage(var index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: primaryColor,
        activeColor: Colors.white,
        initialActiveIndex: currentPageIndex,
        style: TabStyle.reactCircle,
        items: const [
          TabItem(
            icon: Icons.house_siding,
          ),
          TabItem(
            icon: Icons.search,
          ),
          TabItem(
            icon: Icons.storefront,
          ),
          TabItem(
            icon: Icons.shopping_cart_outlined,
          ),
          TabItem(
            icon: Icons.person_outline,
          )
        ],
        onTap: selectPage,
      ),
      body: _pages[currentPageIndex],
    );
  }
}
