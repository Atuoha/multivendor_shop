import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/colors.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/order.dart';

class CustomerOrderScreen extends StatelessWidget {
  static const routeName = '/customer_orders';

  const CustomerOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orderData = Provider.of<OrderData>(context, listen: false);

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
      body: Text(''),
      bottomSheet: Row(
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
                '\$${orderData.orderTotalPrice}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(
                Icons.shopping_cart_checkout,
                color: Colors.white,
              ),
              onPressed: () => {},
              label: const Text(
                'Checkout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
