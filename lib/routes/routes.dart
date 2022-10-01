import 'package:multivendor_shop/views/auth/auth.dart';
import 'package:multivendor_shop/views/auth/forgot_password.dart';

import '../views/auth/account_type_selector.dart';
import '../views/main/customer/customer_bottomNav.dart';
import '../views/splash/entry.dart';
import '../views/splash/splash.dart';

var routes = {
  Auth.routeName: (context) => const Auth(),
  ForgotPassword.routeName: (context) => const ForgotPassword(),
  AccountTypeSelector.routeName: (context) => const AccountTypeSelector(),
  SplashScreen.routeName:(context)=>const SplashScreen(),
  EntryScreen.routeName:(context)=> const EntryScreen(),
  CustomerBottomNav.routeName:(context)=>const CustomerBottomNav()
};
