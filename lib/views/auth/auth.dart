import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multivendor_shop/views/auth/forgot_password.dart';
import '../../components/loading.dart';
import '../../constants/colors.dart';
import '../../helpers/image_picker.dart';
import '../main/customer/customer_bottomNav.dart';
import '../main/seller/seller_bottomNav.dart';

// for fields
enum Field {
  fullname,
  email,
  password,
}

class Auth extends StatefulWidget {
  static const routeName = '/customer-auth';

  const Auth({
    Key? key,
    this.isSellerReg = false,
  }) : super(key: key);
  final bool isSellerReg;

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _passwordController = TextEditingController();
  var obscure = true; // password obscure value
  var isLogin = true;
  File? profileImage;
  var isLoading = false;
  final _auth = FirebaseAuth.instance;
  final firebase = FirebaseFirestore.instance;

  // toggle password obscure
  _togglePasswordObscure() {
    setState(() {
      obscure = !obscure;
    });
  }

  // snackbar for error message
  showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        action: SnackBarAction(
          onPressed: () => Navigator.of(context).pop(),
          label: 'Dismiss',
          textColor: Colors.white,
        ),
      ),
    );
  }

  // custom textfield for all form fields
  Widget kTextField(
    TextEditingController controller,
    String hint,
    String label,
    Field field,
    bool obscureText,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: field == Field.email
          ? TextInputType.emailAddress
          : TextInputType.text,
      textInputAction:
          field == Field.password ? TextInputAction.done : TextInputAction.next,
      autofocus: field == Field.email ? true : false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: primaryColor),
        suffixIcon: field == Field.password
            ? _passwordController.text.isNotEmpty
                ? IconButton(
                    onPressed: () => _togglePasswordObscure(),
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                      color: primaryColor,
                    ),
                  )
                : const SizedBox.shrink()
            : const SizedBox.shrink(),
        hintText: hint,
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
        switch (field) {
          case Field.email:
            if (!value!.contains('@')) {
              return 'Email is not valid!';
            }
            if (value.isEmpty) {
              return 'Email can not be empty';
            }
            break;

          case Field.fullname:
            if (value!.isEmpty || value.length < 3) {
              return 'Fullname is not valid';
            }
            break;

          case Field.password:
            if (value!.isEmpty || value.length < 8) {
              return 'Password needs to be valid';
            }
            break;
        }
        return null;
      },
    );
  }

  // for selecting photo
  _selectPhoto(File image) {
    setState(() {
      profileImage = image;
    });
  }

  // loading fnc
  isLoadingFnc() {
    setState(() {
      isLoading = true;
    });
    Timer(const Duration(seconds: 5), () {
      if (widget.isSellerReg) {
        // seller account
        Navigator.of(context).pushNamed(SellerBottomNav.routeName);
      } else {
        // customer account
        Navigator.of(context).pushNamed(CustomerBottomNav.routeName);
      }
    });
  }

  // handle sign in and  sign up
  _handleAuth() async {
    var valid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    _formKey.currentState!.save();
    if (!valid) {
      return null;
    }

    try {
      if (isLogin) {
        // TODO: implement sign in
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        isLoadingFnc(); // spin and redirect
      } else {
        // TODO: implement sign up

        if (profileImage == null) {
          // profile image is empty
          showSnackBar('Profile image can not be empty!');
          return null;
        }

        var credential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user-images')
            .child('${credential.user!.uid}.jpg');

        File? file;
        file = File(profileImage!.path);

        try {
          await storageRef.putFile(file);
          var downloadUrl = await storageRef.getDownloadURL();
          if (widget.isSellerReg) {
            firebase.collection('sellers').doc(credential.user!.uid).set({
              'fullname': _fullnameController.text.trim(),
              'email': _emailController.text.trim(),
              'image': downloadUrl,
              'auth-type': 'email',
              'phone': '',
              'address': '',
            });
          } else {
            firebase.collection('customers').doc(credential.user!.uid).set({
              'fullname': _fullnameController.text.trim(),
              'email': _emailController.text.trim(),
              'image': downloadUrl,
              'auth-type': 'email',
              'phone': '',
              'address': '',
            });
          }

          isLoadingFnc();
        } catch (e) {
          if (kDebugMode) {
            showSnackBar('An error occurred with image uploading');
          }
          if (kDebugMode) {
            print('AN ERROR OCCURRED! $e');
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      var error = 'An error occurred. Check credentials!';
      if (e.message != null) {
        if (e.code == 'user-not-found') {
          error = "Email not recognised!";
        } else if (e.code == 'account-exists-with-different-credential') {
          error = "Email already in use!";
        } else if (e.code == 'wrong-password') {
          error = 'Email or Password Incorrect!';
        } else if (e.code == 'network-request-failed') {
          error = 'Network error!';
        } else {
          error = e.code;
        }
      }

      showSnackBar(error); // showSnackBar will show error if any
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('AN ERROR OCCURRED! $e');
      }
    }
  }

// authenticate using Google
  Future<UserCredential> _googleAuth() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      // send username, email, and phone number to firestore
      var logCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (widget.isSellerReg) {
        await FirebaseFirestore.instance
            .collection('sellers')
            .doc(logCredential.user!.uid)
            .set(
          {
            'fullname': googleUser!.displayName,
            'email': googleUser.email,
            'image': googleUser.photoUrl,
            'auth-type': 'google',
            'phone': '',
            'address': '',
          },
        ).then((value) {
          isLoadingFnc();
        });
      } else {
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(logCredential.user!.uid)
            .set(
          {
            'fullname': googleUser!.displayName,
            'email': googleUser.email,
            'image': googleUser.photoUrl,
            'auth-type': 'google',
            'phone': '',
            'address': '',
          },
        ).then((value) {
          isLoadingFnc();
        });
      }
    } on FirebaseAuthException catch (e) {
      var error = 'An error occurred. Check credentials!';
      if (e.message != null) {
        error = e.message!;
      }
      showSnackBar(error); // showSnackBar will show error if any
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    // sign in with credential
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  // navigate to forgot password screen
  _forgotPassword() {
    Navigator.of(context).pushNamed(ForgotPassword.routeName);
  }

  _switchLog() {
    setState(() {
      isLogin = !isLogin;
      _passwordController.text = "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                !isLogin
                    ? ProfileImagePicker(selectImage: _selectPhoto)
                    : Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 60,
                          child: Image.asset('assets/images/login.png'),
                        ),
                      ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.isSellerReg
                        ? isLogin
                            ? 'Seller Signin '
                            : 'Seller Signup'
                        : isLogin
                            ? 'Customer Signin '
                            : 'Customer Signup',
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const Center(
                        child: Loading(
                          color: primaryColor,
                          kSize: 70,
                        ),
                      )
                    : Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            kTextField(
                              _emailController,
                              'doe@gmail.com',
                              'Email Address',
                              Field.email,
                              false,
                            ),
                            const SizedBox(height: 10),
                            !isLogin
                                ? kTextField(
                                    _fullnameController,
                                    'John Doe',
                                    'Fullname',
                                    Field.fullname,
                                    false,
                                  )
                                : const SizedBox.shrink(),
                            SizedBox(height: isLogin ? 0 : 10),
                            kTextField(
                              _passwordController,
                              '********',
                              'Password',
                              Field.password,
                              obscure,
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
                                icon: Icon(
                                  isLogin
                                      ? Icons.person
                                      : Icons.person_add_alt_1,
                                  color: Colors.white,
                                ),
                                onPressed: () => _handleAuth(),
                                label: Text(
                                  isLogin ? 'Signin Account' : 'Signup Account',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(15),
                              ),
                              onPressed: () => _googleAuth(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/google.png',
                                    width: 20,
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    isLogin
                                        ? 'Signin with google'
                                        : 'Signup with google',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => _forgotPassword(),
                                  child: const Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _switchLog(),
                                  child: Text(
                                    isLogin
                                        ? 'New here? Create Account'
                                        : 'Already a user? Sign in',
                                    style: const TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
