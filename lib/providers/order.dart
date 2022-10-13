import 'package:flutter/material.dart';
import 'package:multivendor_shop/models/order.dart';

import '../models/cart.dart';

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

  var _totalOrderAmount = 0.0;

  List<CartItem> pullSpecificOrders(String id) {
    _totalOrderAmount = 0.0;
    List<CartItem> items = [];
    for (var order in _orderItems) {
      for (var item in order.items) {
        if (item.sellerId == id) {
          items.add(item);
          _totalOrderAmount += item.prodPrice;
        }
      }
    }
    return items;
  }

  get totalOrderAmount {
    return _totalOrderAmount;
  }

  DateTime? getOrderDate(String id) {
    DateTime? date;
    for (var item in _orderItems) {
      for (var cartItem in item.items) {
        if (cartItem.id == id) {
          date = item.orderDate;
        }
      }
    }

    return date;
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
