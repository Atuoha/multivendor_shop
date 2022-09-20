import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';

// for fields
enum Field {
  fullname,
  email,
  password,
}

// for photo selection
enum Source { camera, gallery }

class CustomerLandingScreen extends StatefulWidget {
  const CustomerLandingScreen({Key? key}) : super(key: key);

  @override
  State<CustomerLandingScreen> createState() => _CustomerLandingScreenState();
}

class _CustomerLandingScreenState extends State<CustomerLandingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _passwordController = TextEditingController();
  var obscure = true; // password obscure value

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
      decoration: InputDecoration(
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
            width: 1,
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
        }
        return null;
      },
    );
  }

  // for selecting photo
  _selectPhoto(Source source) {
    print(source);
  }

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

  // sign up
  _signUp() {}

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
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Register as a customer',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.person_add_alt_1,
                  color: primaryColor,
                  size: 35,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Center(
                    child: Image.asset(
                      'assets/images/profile.png',
                      color: primaryColor,
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
                    Field.email,
                    false,
                  ),
                  const SizedBox(height: 10),
                  kTextField(
                    _fullnameController,
                    'John Doe',
                    Field.fullname,
                    false,
                  ),
                  const SizedBox(height: 10),
                  kTextField(
                    _passwordController,
                    '********',
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
                          padding: const EdgeInsets.all(15)),
                      icon: const Icon(
                        Icons.person_add_alt_1,
                        color: Colors.white,
                      ),
                      onPressed: () => _signUp(),
                      label: const Text(
                        'Signup',
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
