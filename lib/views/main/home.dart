import 'package:flutter/material.dart';
import 'package:multivendor_shop/constants/colors.dart';

import '../../components/search_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              child: const SearchBox()),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
              labelStyle: TextStyle(color: Colors.black),
              labelColor: Colors.black,
              indicatorColor: primaryColor,
              tabs: [
                Tab(text: 'Women'),
                Tab(text: 'Men'),
                Tab(text: 'Children'),
                Tab(text: 'Others'),
              ]),
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(
              18.0,
              50,
              18,
              0,
            ),
            child: TabBarView(children: [
              Center(child: Text('hello')),
              Center(child: Text('hello2')),
              Center(child: Text('hello3')),
              Center(child: Text('hello4')),
            ])),
      ),
    );
  }
}
