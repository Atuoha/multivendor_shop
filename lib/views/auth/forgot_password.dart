import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multivendor_shop/views/auth/auth.dart';
import '../../constants/colors.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = '/forgot-password';

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  // handle forgot password
  _handleForgotPassword() {
    var valid = _formKey.currentState!.validate();
    if (!valid) {
      return null;
    }
    // TODO: Implement forgot password
  }

  // navigate to sign in screen
  _navigateToSignIn() {
    Navigator.of(context).pushNamed(Auth.routeName);
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
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 60,
                child: Image.asset('assets/images/forgot.png'),
              ),
            ),
            const Center(
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  TextFormField(
                    autofocus: true,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'doe@gmail.com',
                      labelText: 'Email Address',
                      labelStyle: const TextStyle(color: primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          width: 2,
                          color: primaryColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (!value!.contains('@')) {
                        return 'Email is not valid!';
                      }
                      if (value.isEmpty) {
                        return 'Email can not be empty';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(15),
                      ),
                      icon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      onPressed: () => _handleForgotPassword(),
                      label: const Text(
                        'Submit Request',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _navigateToSignIn(),
                    child: const Text(
                      'Remembered password? Sign in',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
