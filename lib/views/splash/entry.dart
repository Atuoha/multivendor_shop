import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:multivendor_shop/views/splash/splash.dart';
import '../../components/loading.dart';
import '../../constants/colors.dart';
import '../auth/account_type_selector.dart';
import '../main/bottomNav.dart';

class EntryScreen extends StatefulWidget {
  static const routeName = '/entry-screen';

  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  _startRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    var duration = const Duration(seconds: 5);
    if (ifr != null && !ifr) {
      Timer(duration, _navigateToAuthOrHome);
    } else {
      Timer(duration, _navigateToSplash);
    }
  }

  _navigateToSplash() {
    // Routing to Splash
    Navigator.of(context).pushNamed(SplashScreen.routeName);
  }

  _navigateToAuthOrHome() {
    //Routing to Account Selection Type or Home
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // home screen
        Navigator.of(context).pushNamed(BottomNav.routeName);
      } else {
        // auth screen
        Navigator.of(context).pushNamed(AccountTypeSelector.routeName);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startRun();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo1.png'),
            const SizedBox(height: 10),
            const Loading(
              color: Colors.white,
              kSize: 40,
            ),
          ],
        ),
      ),
    );
  }
}
