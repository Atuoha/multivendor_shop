import 'package:multivendor_shop/views/auth/customer_auth.dart';
import 'package:multivendor_shop/views/auth/forgot_password.dart';

import '../views/auth/account_type_selector.dart';

var routes = {
  CustomerAuth.routeName: (context) => const CustomerAuth(),
  ForgotPassword.routeName: (context) => const ForgotPassword(),
  AccountTypeSelector.routeName: (context) => const AccountTypeSelector()
};
