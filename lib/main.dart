import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multivendor_shop/views/splash/entry.dart';
import 'routes/routes.dart';
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



class MultiVendor extends StatefulWidget {
  const MultiVendor({Key? key}) : super(key: key);

  @override
  State<MultiVendor> createState() => _MultiVendorState();
}

class _MultiVendorState extends State<MultiVendor> {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiVendor App',
      theme: ThemeData(fontFamily: 'Roboto'),
      debugShowCheckedModeBanner: false,
      home: const EntryScreen(),
      routes: routes,
    );
  }
}
