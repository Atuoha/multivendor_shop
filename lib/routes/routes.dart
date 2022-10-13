import 'package:multivendor_shop/views/auth/auth.dart';
import 'package:multivendor_shop/views/auth/forgot_password.dart';
import 'package:multivendor_shop/views/main/customer/edit_profile.dart';
import 'package:multivendor_shop/views/main/seller/dashboard_screens/account_balance.dart';
import 'package:multivendor_shop/views/main/seller/dashboard_screens/manage_products.dart';
import 'package:multivendor_shop/views/main/seller/dashboard_screens/orders.dart';
import 'package:multivendor_shop/views/main/seller/dashboard_screens/statistics.dart';
import 'package:multivendor_shop/views/main/seller/dashboard_screens/store_setup.dart';
import 'package:multivendor_shop/views/main/seller/seller_bottomNav.dart';
import '../views/auth/account_type_selector.dart';
import '../views/main/customer/customer_bottomNav.dart';
import '../views/main/customer/order.dart';
import '../views/main/seller/dashboard_screens/edit_product.dart';
import '../views/main/seller/dashboard_screens/upload_product.dart';
import '../views/splash/entry.dart';
import '../views/splash/splash.dart';

var routes = {
  Auth.routeName: (context) => const Auth(),
  ForgotPassword.routeName: (context) => const ForgotPassword(),
  AccountTypeSelector.routeName: (context) => const AccountTypeSelector(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  EntryScreen.routeName: (context) => const EntryScreen(),
  CustomerBottomNav.routeName: (context) => const CustomerBottomNav(),
  SellerBottomNav.routeName: (context) => const SellerBottomNav(),
  ManageProductsScreen.routeName: (context) => const ManageProductsScreen(),
  UploadProduct.routeName: (context) => const UploadProduct(),
  OrdersScreen.routeName: (context) => const OrdersScreen(),
  StoreSetupScreen.routeName: (context) => const StoreSetupScreen(),
  StatisticsScreen.routeName: (context) => const StatisticsScreen(),
  AccountBalanceScreen.routeName: (context) => const AccountBalanceScreen(),
  CustomerOrderScreen.routeName: (context)=>const CustomerOrderScreen(),
  EditProduct.routeName: (context)=> const EditProfile(),
};
