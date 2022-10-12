import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../constants/colors.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/order.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

import '../product/details.dart';

class CustomerOrderScreen extends StatelessWidget {
  static const routeName = '/customer_orders';

  const CustomerOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orderData = Provider.of<OrderData>(context, listen: false);

    // remove from order
    void removeFromOrder(String id) {
      orderData.removeFromOrder(id);
    }

    // pay through stripe
    void payNow() async {
      // TODO: Implement Pay now
    }

    // payNow Dialog
    void payNowDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pay Now'),
          content: Text(
            'Are you sure you want to pay now; \$${orderData.orderTotalPrice} ?',
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => payNow(),
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
              onPressed: () => Navigator.of(context).pop(false),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5,
        ),
        child: Consumer<OrderData>(
          builder: (context, data, child) {
            if (data.orderItems.isEmpty) {
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
              itemCount: data.orderItemCount,
              itemBuilder: (context, index) {
                var item = data.orderItems[index];
                var date = intl.DateFormat.yMMMEd().format(item.orderDate);
                return Dismissible(
                  onDismissed: (direction) => removeFromOrder(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    height: 115,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  confirmDismiss: (direction) => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Remove order on $date'),
                      content: Text(
                        'Are you sure you want to remove order on $date ?',
                      ),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
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
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  key: ValueKey(item.id),
                  child: Card(
                    elevation: 3,
                    child: ExpansionTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: primaryColor,
                        ),
                      ),
                      title: Text(
                        date.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        '\$${item.totalPrice}',
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      iconColor: primaryColor,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: item.items.length,
                          itemBuilder: (context, index) {
                            var subData = item.items[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: primaryColor,
                                backgroundImage:
                                    NetworkImage(subData.prodImgUrl),
                              ),
                              title: Text(
                                subData.prodName,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text('\$${subData.totalPrice}'),
                              trailing: IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('products')
                                      .doc(subData.docId)
                                      .get()
                                      .then(
                                        (value) => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailsScreen(product: value),
                                          ),
                                        ),
                                      );
                                },
                                icon: const Icon(
                                  Icons.chevron_right,
                                  color: primaryColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
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
                  Icons.credit_card,
                  color: Colors.white,
                ),
                onPressed: () => payNowDialog(),
                label: const Text(
                  'Pay now',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
