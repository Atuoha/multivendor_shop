import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multivendor_shop/providers/order.dart';
import 'package:provider/provider.dart';
import '../../../../constants/colors.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final orderData =  Provider.of<OrderData>(context, listen: false);
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
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Consumer<OrderData>(
        builder: (
          context,
          data,
          child,
        ) {
          if (data.pullSpecificOrders(userId).isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/sad.png'),
                const SizedBox(height: 10),
                const Text(
                  'No order to display',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            );
          }

          return ListView.builder(
            itemCount: data.pullSpecificOrders(userId).length,
            itemBuilder: (context, index) {
              var item = data.pullSpecificOrders(userId)[index];

              return ListTile();
            },
          );
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '\$${orderData.totalOrderAmount}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    color: primaryColor,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
