import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/colors.dart';
import '../../../utilities/products_stream_builder.dart';

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({
    Key? key,
    required this.category,
    required this.subCategory,
  }) : super(key: key);
  final String subCategory;
  final String category;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .where('sub_category', isEqualTo: subCategory)
        .snapshots();

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
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          '$subCategory - $category',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
