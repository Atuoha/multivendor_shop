import 'cart.dart';

class Order {
  final String id;
  final double totalPrice;
  final List<CartItem> items;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.totalPrice,
    required this.items,
    required this.orderDate,
  });
}
