import 'package:flutter/material.dart';
import 'package:multivendor_shop/views/auth/customer_landing_screen.dart';

void main()=> runApp(MultiVendor());

class MultiVendor extends StatelessWidget{
  const MultiVendor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'MultiVendor App',
        debugShowCheckedModeBanner: false,
        home:CustomerLandingScreen(),

    );
  }
}