import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multivendor_shop/views/auth/forgot_password.dart';
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
      autofocus: field == Field.email ? true: false,
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

  // handle sign in and  sign up
  _handleAuth() {
    var valid = _formKey.currentState!.validate();
    if (!valid) {
      return null;
    }

    if (isLogin) {
      // TODO: implement sign in
    } else {
      // TODO: implement sign up
    }
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
                Form(
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
                            isLogin ? Icons.person : Icons.person_add_alt_1,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => _forgotPassword(),
                            child: const Text(
                              'Forgot Password',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
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
                                fontWeight: FontWeight.w500,
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
