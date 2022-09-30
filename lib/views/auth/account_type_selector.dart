import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multivendor_shop/views/auth/auth.dart';
import '../../constants/colors.dart';

class AccountTypeSelector extends StatefulWidget {
  static const routeName = '/account-type-selector';

  const AccountTypeSelector({Key? key}) : super(key: key);

  @override
  State<AccountTypeSelector> createState() => _AccountTypeSelectorState();
}

class _AccountTypeSelectorState extends State<AccountTypeSelector> {
  var typeIndex = 0;
  var accountType = ['Customer Account', 'Seller Account'];

  Widget kContainer(int index) {
    return GestureDetector(
      onTap: () => setState(() {
        typeIndex = index;
      }),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: typeIndex == index
              ? Border.all(
                  width: 1,
                  color: Colors.white,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/profile.png',
                color: Colors.white,
                width: 134,
              ),
              Text(
                accountType[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _navigateToSection() {
    if (typeIndex == 0) {
      // registering as a customer
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Auth(),
        ),
      );
    } else {
      // registering as a seller
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Auth(
            isSellerReg: true,
          ),
        ),
      );
    }
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
        color: primaryColor,
        constraints: const BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  kContainer(0),
                  const SizedBox(width: 50),
                  kContainer(1),
                ],
              ),
              const SizedBox(height: 30),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(15),
                  ),
                  icon: const Icon(
                    Icons.chevron_left,
                    color: primaryColor,
                  ),
                  onPressed: () => _navigateToSection(),
                  label: const Text(
                    'Continue',
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
