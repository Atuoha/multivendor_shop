import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multivendor_shop/views/auth/forgot_password.dart';
import '../../components/loading.dart';
import '../../constants/colors.dart';

// for fields
enum Field {
  fullname,
  email,
  password,
}

// for photo selection
enum Source { camera, gallery }

class CustomerAuth extends StatefulWidget {
  static const routeName = '/customer-auth';

  const CustomerAuth({Key? key}) : super(key: key);

  @override
  State<CustomerAuth> createState() => _CustomerAuthState();
}

class _CustomerAuthState extends State<CustomerAuth> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _passwordController = TextEditingController();
  var obscure = true; // password obscure value
  var isLogin = true;
  XFile? profileImage;
  final ImagePicker _picker = ImagePicker(); // init imagePicker
  var isLoading = false;
  final _auth = FirebaseAuth.instance;
  final firebase = FirebaseFirestore.instance;

  // toggle password obscure
  _togglePasswordObscure() {
    setState(() {
      obscure = !obscure;
    });
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
  Future _selectPhoto(Source source) async {
    XFile? pickedImage;
    switch (source) {
      case Source.camera:
        pickedImage = await _picker.pickImage(
            source: ImageSource.camera, maxWidth: 600, maxHeight: 600);
        break;
      case Source.gallery:
        pickedImage = await _picker.pickImage(
            source: ImageSource.gallery, maxWidth: 600, maxHeight: 600);
        break;
    }
    if (pickedImage == null) {
      return null;
    }

    // assign the picked image to the profileImage
    setState(() {
      profileImage = pickedImage;
    });
  }

  // widget for each profile image selector
  Widget kContainer(Source source) {
    return GestureDetector(
      onTap: () => _selectPhoto(source),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: source == Source.gallery
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
        ),
        child: Center(
          child: Icon(
            source == Source.gallery ? Icons.photo : Icons.camera_alt_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // snackbar for error message
  void showSnackBar(String message) {
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

  // loading fnc
  isLoadingFnc() {
    setState(() {
      isLoading = true;
    });
    // Timer(const Duration(seconds: 5), () {
    //   Navigator.of(context).pushNamed('');
    // });
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
          firebase.collection('users').doc(credential.user!.uid).set({
            'fullname': _fullnameController.text.trim(),
            'email': _emailController.text.trim(),
            'image': downloadUrl
          });
          isLoadingFnc();
        } catch (e) {
          showSnackBar('An error occurred with image uploading');
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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(logCredential.user!.uid)
          .set(
        {
          'username': googleUser!.displayName,
          'email': googleUser.email,
          'image': googleUser.photoUrl,
          'auth-type': 'google',
        },
      ).then((value) {
        // isLoadingFnc();
        // update authtype
        // Provider.of<SongData>(context).updateAuthType();
      });
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
    // sign in with credential¶
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
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: profileImage == null ? 60 : 80,
                            backgroundColor: Colors.white,
                            child: Center(
                              child: profileImage == null
                                  ? Image.asset(
                                      'assets/images/profile.png',
                                      color: primaryColor,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.file(
                                        File(profileImage!.path),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Column(
                            children: [
                              kContainer(Source.gallery),
                              const SizedBox(height: 5),
                              kContainer(Source.camera)
                            ],
                          )
                        ],
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    isLogin ? 'Customer Signin ' : 'Customer Signup',
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
                          kSize: 100,
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
