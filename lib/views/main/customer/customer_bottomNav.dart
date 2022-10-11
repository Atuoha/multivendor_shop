import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';
import 'package:multivendor_shop/constants/colors.dart';
import 'package:provider/provider.dart';
import '../../../providers/cart.dart';
import 'cart.dart';
import 'favorites.dart';
import 'home.dart';
import 'profile.dart';
import 'category.dart';
import '../store/store.dart';

class CustomerBottomNav extends StatefulWidget {
  static const routeName = '/customer-home';

  const CustomerBottomNav({Key? key}) : super(key: key);

  @override
  State<CustomerBottomNav> createState() => _CustomerBottomNavState();
}

class _CustomerBottomNavState extends State<CustomerBottomNav> {
  var currentPageIndex = 0;
  final _pages = const [
    HomeScreen(),
    FavoriteScreen(),
    CategoryScreen(),
    StoreScreen(),
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
    var cartData = Provider.of<CartData>(context, listen: false);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: litePrimary,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.grey,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: primaryColor,
        activeColor: Colors.white,
        initialActiveIndex: currentPageIndex,
        style: TabStyle.reactCircle,
        items: [
          TabItem(
            icon: Icons.house_siding,
          ),
          TabItem(
            icon: Icons.favorite_border,
          ),
          TabItem(
            icon: Icons.category_outlined,
          ),
          TabItem(
            icon: Icons.storefront,
          ),
          TabItem(
            icon: Consumer<CartData>(
              builder: (context, data, child) => Badge(
                badgeContent: Text(
                  cartData.cartItemCount.toString(),
                  style: const TextStyle(
                    color: primaryColor,
                  ),
                ),
                child:  Icon(
                  Icons.shopping_bag_outlined,
                  size: currentPageIndex == 4 ? 40 : 25,
                  color: currentPageIndex == 4 ? primaryColor : Colors.white70,
                ),
              ),
            ),
          ),
          TabItem(
            icon: Icons.person_outline,
          )
        ],
        onTap: selectPage,
      ),
      backgroundColor: Colors.grey.shade200,
      body: _pages[currentPageIndex],
    );
  }
}
