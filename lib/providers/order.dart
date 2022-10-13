import 'package:flutter/material.dart';
import 'package:multivendor_shop/models/order.dart';

class OrderData extends ChangeNotifier {
  var totalPrice = 0.0;

  void addToOrder(Order order) {
    Order item = Order(
      id: DateTime.now().toString(),
      totalPrice: order.totalPrice,
      items: order.items,
      orderDate: DateTime.now(),
    );

    _orderItems.add(item);
    notifyListeners();
  }

  void pullSpecificOrders(String id){
    
  }

  void removeFromOrder(String id) {
    var orderItem = _orderItems.firstWhere(
      (item) => item.id == id,
    );
    _orderItems.remove(orderItem);
    notifyListeners();
  }

  get orderItemCount {
    return _orderItems.length;
  }

  List<Order> get orderItems {
    return [..._orderItems];
  }

  get orderTotalPrice {
    totalPrice = 0.0;
    for (var item in _orderItems) {
      totalPrice += item.totalPrice;
    }
    return totalPrice;
  }

  final _orderItems = [];
}
