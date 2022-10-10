import 'package:flutter/material.dart';

class OrderData extends ChangeNotifier {
  var totalPrice = 0.0;

  void removeFromOrder(String id) {
    var orderItem = _orderItems.firstWhere((item) => item.id == id);
    _orderItems.remove(orderItem);
    notifyListeners();
  }

  get orderItemCount {
    return _orderItems.length;
  }

  get orderItems {
    return [..._orderItems];
  }

  get orderTotalPrice {
    for (var item in _orderItems) {
      totalPrice += item.totalPrice;
    }
    return totalPrice;
  }

  final _orderItems = [];
}
