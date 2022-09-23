import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:multivendor_shop/models/item_data.dart';
import '../../constants/colors.dart';
import '../auth/account_type_selector.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int page = 0;
  late LiquidController liquidController;

  final List<ItemData> pages = [
    ItemData(
      primaryColor,
      'assets/images/sp5.png',
      'Multivendz',
      'A place to find the best',
      contentStyle2,
      titleStyle2,
      Colors.white,
    ),
    ItemData(
      Colors.white,
      'assets/images/sp2.png',
      'Swift checkouts',
      'Ensuring swift checkouts',
      contentStyle1,
      titleStyle1,
      primaryColor,
    ),
    ItemData(
      primaryColor,
      'assets/images/sp3.png',
      'Easy buy',
      'We\'ve made the process friendly',
      contentStyle2,
      titleStyle2,
      Colors.white,
    ),
    ItemData(
      Colors.white,
      'assets/images/sp4.png',
      'Wholesome happiness',
      'We\'ll make your happiness a priority',
      contentStyle1,
      titleStyle1,
      primaryColor,
    ),
    ItemData(
      primaryColor,
      'assets/images/sp6.png',
      'We deliver',
      'Packages at your door step',
      contentStyle2,
      titleStyle2,
      Colors.white,
    ),
    ItemData(
      Colors.white,
      'assets/images/sp1.png',
      'Box in',
      'Let\'s make it easy for you',
      contentStyle1,
      titleStyle1,
      primaryColor,
    ),
  ];

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }

  Widget _buildDot(int index) {
    double select = Curves.easeOut.transform(
      max(0.0, 1.0 - (page - index).abs()),
    );
    double zoom = 1.0 + (2.0 - 1.0) * select;
    return SizedBox(
      width: 25.0,
      child: Center(
        child: Material(
          color: pages[page].btnColor,
          type: MaterialType.circle,
          child: SizedBox(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    liquidController = LiquidController();
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
      body: Stack(
        children: [
          LiquidSwipe.builder(
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                color: pages[index].color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      pages[index].image,
                      height: 400,
                      fit: BoxFit.contain,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          pages[index].title,
                          style: pages[index].titleStyle,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          pages[index].content,
                          style: pages[index].contentStyle,
                        ),
                        page == pages.length - 1
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 10),
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          primary: primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                        ),
                                        icon: const Icon(
                                          Icons.chevron_left,
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pushNamed(
                                          AccountTypeSelector.routeName,
                                        ),
                                        label: const Text(
                                          'Get started',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ],
                ),
              );
            },
            slideIconWidget: page != pages.length - 1
                ? Icon(
                    Icons.arrow_back_ios,
                    color: pages[page].color,
                  )
                : const SizedBox.shrink(),
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            enableSideReveal: true,
            ignoreUserGestureWhileAnimating: true,
          ),
          page != pages.length - 1
              ? Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                const Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(pages.length, _buildDot),
                ),
              ],
            ),
          ): const SizedBox.shrink(),
          page != pages.length - 1
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextButton(
                      onPressed: () {
                        liquidController.animateToPage(
                          page: pages.length - 1,
                          duration: 700,
                        );
                      },
                      child: Text(
                        "Skip to End",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: pages[page].btnColor,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          page != pages.length - 1
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextButton(
                      onPressed: () {
                        liquidController.jumpToPage(
                            page: liquidController.currentPage + 1 >
                                    pages.length - 1
                                ? 0
                                : liquidController.currentPage + 1);
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: pages[page].btnColor,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
