import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../utilities/k_stream_builder.dart';

class ChildrenWears extends StatelessWidget {
  const ChildrenWears({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final firestore = FirebaseFirestore.instance;

    final Stream<QuerySnapshot> productStream = firestore
        .collection('products')
        .where('category', isEqualTo: 'Children')
        .snapshots();

    return Column(
      children: [
        SizedBox(
          height: size.height / 1.5,
          child: KStreamBuilder(
            productStream: productStream,
          ),
        )
      ],
    );
  }
}
