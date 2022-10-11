import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/cart.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var cartData = Provider.of<CartData>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width / 1.22,
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              prefixIcon: Icon(Icons.search, color: greyLite),
              suffixIcon: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text('Search'),
              ),
              hintText: 'Type here...',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 1,
                  color: primaryColor,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 20,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ),
        Consumer<CartData>(builder: (context, data, child)=>
          Badge(
            badgeContent: Text(
              cartData.cartItemCount.toString(),
              style: const TextStyle(
                color: primaryColor,
              ),
            ),
            showBadge: cartData.cartItems.isNotEmpty ? true:false,
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 30,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
