import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multivendor_shop/providers/order.dart';
import 'package:provider/provider.dart';
import '../../../../constants/colors.dart';
import 'package:intl/intl.dart' as intl;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var userId = FirebaseAuth.instance.currentUser!.uid;

  DataRow buildDataRow(String field, dynamic detail) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            field,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
        DataCell(
          Text(
            detail,
            style: const TextStyle(color: Colors.grey),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderData>(context, listen: false);
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
          'My Orders',
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

              var userDetails = FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(item.userId)
                  .get();

              var date = intl.DateFormat.yMMMEd()
                  .format(orderData.getOrderDate(item.id)!);
              return ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: primaryColor,
                  backgroundImage: NetworkImage(item.prodImgUrl),
                ),
                title: Text(
                  item.prodName,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price: ${item.totalPrice}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Quantity: ${item.quantity}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                iconColor: primaryColor,
                children: [
                  FutureBuilder<DocumentSnapshot>(
                    future: userDetails,
                    builder: (context, AsyncSnapshot<DocumentSnapshot>snapshot) => DataTable(
                      columns: const [
                        DataColumn(label: Text('Section')),
                        DataColumn(label: Text('Information'))
                      ],
                      rows: [
                        buildDataRow('Order Date', date),
                        buildDataRow('Customer', snapshot.data!['fullname']),
                        buildDataRow(
                            'Billing Address', snapshot.data!['address']),
                        buildDataRow('Email', snapshot.data!['email']),
                        buildDataRow('Contact', snapshot.data!['phone']),
                      ],
                    ),
                  )
                ],
              );
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
