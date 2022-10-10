import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../components/search_box.dart';
import '../../../constants/colors.dart';
import '../../../utilities/products_stream_builder.dart';
import '../product_categories/children.dart';
import '../product_categories/men.dart';
import '../product_categories/others.dart';
import '../product_categories/sneakers.dart';
import '../product_categories/women.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
      .collection('products')
      .where('isFav', isEqualTo: true)
      .snapshots();

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
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.2,
              child: ProductStreamBuilder(
                productStream: productStream,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
