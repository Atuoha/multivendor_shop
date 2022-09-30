import 'package:flutter/material.dart';

import '../../components/search_box.dart';
import '../../constants/colors.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
        right: 18.0,
        left: 18.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SearchBox(),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/love.gif'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'No favorite products',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: primaryColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
