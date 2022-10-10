import 'package:flutter/material.dart';

class CartData extends ChangeNotifier {
  var totalPrice = 0.0;

  void incrementProductQuantity(String id) {
    var cartItem = _cartItems.firstWhere((item) => item.id == id);
    cartItem.incrementQuantity();
    notifyListeners();
  }

  void decrementProductQuantity(String id) {
    var cartItem = _cartItems.firstWhere((item) => item.id == id);
    cartItem.decrementQuantity();
    notifyListeners();
  }

  void removeFromCart(String id) {
    var cartItem = _cartItems.firstWhere((item) => item.id == id);
    _cartItems.remove(cartItem);
    notifyListeners();
  }

  get cartItemCount {
    return _cartItems.length;
  }

  get cartTotalPrice {
    for (var item in _cartItems) {
      totalPrice += item.totalPrice;
    }
    return totalPrice;
  }

  get cartItems {
    return [..._cartItems];
  }

  final _cartItems = [];
}
