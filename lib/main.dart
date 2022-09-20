import 'package:flutter/material.dart';
import 'package:multivendor_shop/views/auth/customer_auth.dart';

import 'controllers/routes.dart';

void main()=> runApp(const MultiVendor());

class MultiVendor extends StatelessWidget{
  const MultiVendor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'MultiVendor App',
        debugShowCheckedModeBanner: false,
        home:CustomerAuth(),
        routes: routes,
    );
  }
}