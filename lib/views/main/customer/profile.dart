import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multivendor_shop/components/loading.dart';
import 'package:multivendor_shop/constants/colors.dart';
import 'package:multivendor_shop/views/auth/account_type_selector.dart';
import 'package:multivendor_shop/views/main/customer/order.dart';
import 'edit_profile.dart';
import '../../../components/kDividerText.dart';
import '../../../components/kListTile.dart';
import '../../auth/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var firebase = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;
  var userId = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot? credential;
  var isLoading = true;
  var isInit = true;

  // fetch user credentials
  _fetchUserDetails() async {
    credential = await firebase.collection('customers').doc(userId).get();
    setState(() {
      isLoading = false;
    });
  }

  showLogoutOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Image.asset(
              'assets/images/profile.png',
              width: 35,
              color: primaryColor,
            ),
            const Text(
              'Logout Account',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => _logout(),
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _logout() {
    auth.signOut();
    Navigator.of(context).pushNamed(AccountTypeSelector.routeName);
  }

  _editProfile() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => const EditProfile(),
          ),
        )
        .then(
          (value) => setState(
            () {},
          ),
        );
  }

  _settings() {
    Navigator.of(context).pushNamed('');
  }

  _changePassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfile(
          editPasswordOnly: true,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isInit) {
      _fetchUserDetails();
    }
    setState(() {
      isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return isLoading
        ? const Center(
            child: Loading(
              color: primaryColor,
              kSize: 50,
            ),
          )
        : CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                expandedHeight: 130,
                backgroundColor: primaryColor,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      title: AnimatedOpacity(
                        opacity: constraints.biggest.height <= 120 ? 1 : 0,
                        duration: const Duration(
                          milliseconds: 300,
                        ),
                        child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: primaryColor,
                                backgroundImage: NetworkImage(
                                  credential!['image'],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                credential!['fullname'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor,
                              Colors.black26,
                            ],
                            stops: [0.1, 1],
                            end: Alignment.topRight,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 65,
                              backgroundColor: primaryColor,
                              backgroundImage: NetworkImage(
                                credential!['image'],
                              ),
                            ),
                            Text(
                              credential!['fullname'],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: size.width / 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  primary: bWhite,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30),
                                    ),
                                  ),
                                ),
                                onPressed: ()=> Navigator.of(context).pushNamed(CustomerOrderScreen.routeName),
                                child: const Text(
                                  'Orders',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  primary: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: (){},
                                child: const Text(
                                  'Wishlist',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  primary: bWhite,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Cart',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const KDividerText(title: 'Account Information'),
                      const SizedBox(height: 20),
                      Container(
                        height: size.height / 2.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            KListTile(
                              title: 'Email Address',
                              subtitle: credential!['email'],
                              icon: Icons.email,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(thickness: 1),
                            ),
                            KListTile(
                              title: 'Phone Number',
                              subtitle: credential!['phone'] == ""
                                  ? 'Not set yet'
                                  : credential!['phone'],
                              icon: Icons.phone,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(thickness: 1),
                            ),
                            KListTile(
                              title: 'Delivery Address',
                              subtitle: credential!['address'] == ""
                                  ? 'Not set yet'
                                  : credential!['address'],
                              icon: Icons.location_pin,
                            ),
                          ],
                        ),
                      ),
                      // const KDividerText(title: 'Account Settings'),
                      const SizedBox(height: 20),
                      Container(
                        height: size.height / 3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            KListTile(
                              title: 'App Settings',
                              icon: Icons.settings,
                              onTapHandler: _settings,
                              showSubtitle: false,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(thickness: 1),
                            ),
                            KListTile(
                              title: 'Edit Profile',
                              icon: Icons.edit_note,
                              onTapHandler: _editProfile,
                              showSubtitle: false,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(thickness: 1),
                            ),
                            KListTile(
                              title: 'Change Password',
                              icon: Icons.key,
                              onTapHandler: _changePassword,
                              showSubtitle: false,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Divider(thickness: 1),
                            ),
                            KListTile(
                              title: 'Logout',
                              icon: Icons.logout,
                              onTapHandler: showLogoutOptions,
                              showSubtitle: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
  }
}
