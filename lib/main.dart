import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multivendor_shop/views/auth/account_type_selector.dart';
import 'package:multivendor_shop/views/auth/customer_auth.dart';

import 'controllers/routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MultiVendor(),
  );
}

class MultiVendor extends StatelessWidget {
  const MultiVendor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiVendor App',
      theme: ThemeData(fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      home: const AccountTypeSelector(),
      routes: routes,
    );
  }
}
