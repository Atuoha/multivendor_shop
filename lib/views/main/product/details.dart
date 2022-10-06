import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/colors.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);
  final String productId;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  var firebase = FirebaseFirestore.instance;
  var isInit = true;
  var isLoading = true;
  var productDetails;

  _fetchDetails() {
    var details = firebase.collection('products').doc(widget.productId).get();
    setState(() {
      productDetails = details;
      isLoading = false;
      isInit = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      _fetchDetails();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      body: Column(
        children: [
          Container(
            height: size.height / 3,
            color:primaryColor,
          )
        ],
      ),
    );
  }
}
