import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

enum Operation { checkoutCart, clearCart }

class _CartScreenState extends State<CartScreen> {
  // confirmation for checkout and clear cart
  confirmOptions(Operation operation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              operation == Operation.clearCart
                  ? Icons.remove_shopping_cart_outlined
                  : Icons.shopping_cart_checkout_outlined,
              color: primaryColor,
            ),
            Text(
              operation == Operation.clearCart
                  ? 'Confirm Clear'
                  : 'Confirm Checkout',
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          operation == Operation.clearCart
              ? 'Are you sure you want to clear cart?'
              : 'Are you sure you want to checkout cart?',
          style: const TextStyle(
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
            onPressed: () =>
                operation == Operation.clearCart ? _clearCart() : _checkOut(),
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

  _clearCart() {
    //TODO: Implement clear cart
  }

  _checkOut() {
    //TODO: Implement checkout cart
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18.0,
        40,
        18,
        0,
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    Icon(
                      Icons.shopping_cart,
                      color: primaryColor,
                    ),
                    Text(
                      'Cart',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.83,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 1.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/sp2.png',
                            width: 250,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Opps! No items to display',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),

                      //child: ListView(
                      //   children: [
                      //     Text(''),
                      //   ],
                      // ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: const [
                                Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '\$0.00',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30,
                                      color: primaryColor),
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
                                onPressed: () =>
                                    confirmOptions(Operation.checkoutCart),
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
                      ),
                    )
                  ],
                ),

                // child:  Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset(
                //         'assets/images/sp2.png',
                //         width: 250,
                //       ),
                //       const SizedBox(height: 10),
                //       const Text(
                //         'Opps! No items on the cart ',
                //         style: TextStyle(
                //           color: primaryColor,
                //           fontSize: 18,
                //         ),
                //       )
                //     ],
                //   ),
              ),
            ],
          ),

          // checkout and clear cart buttons
          Positioned(
            top: 60,
            right: 5,
            child: Container(
              height: 100,
              width: 40,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () => confirmOptions(Operation.clearCart),
                    icon: const Icon(
                      Icons.remove_shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => confirmOptions(Operation.checkoutCart),
                    icon: const Icon(
                      Icons.shopping_cart_checkout_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
