import 'cart.dart';

class Order {
  final String id;
  final int totalPrice;
  final List<CartItem> items;

  Order({
    required this.id,
    required this.totalPrice,
    required this.items,
  });
}
