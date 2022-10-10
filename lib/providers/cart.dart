import 'package:flutter/material.dart';
import 'package:multivendor_shop/models/cart.dart';

class CartData extends ChangeNotifier {
  var totalPrice = 0.0;

  bool isItemOnCart(String prodId) {
    return _cartItems.any((item) => item.prodId == prodId);
  }

  void incrementProductQuantity(String id) {
    var cartItem = _cartItems.firstWhere(
      (item) => item.id == id,
    );
    cartItem.incrementQuantity();
    notifyListeners();
  }

  void decrementProductQuantity(String id) {
    var cartItem = _cartItems.firstWhere(
      (item) => item.id == id,
    );
    cartItem.decrementQuantity();
    if (cartItem.quantity < 1) {
      _cartItems.remove(cartItem);
    }
    notifyListeners();
  }

  void addToCart(CartItem cart) {
    CartItem item = CartItem(
      id: DateTime.now().toString(),
      prodId: cart.prodId,
      prodName: cart.prodName,
      prodPrice: cart.prodPrice,
      prodImgUrl: cart.prodImgUrl,
      totalPrice: cart.totalPrice,
    );

    _cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(String prodId) {
    var cartItem = _cartItems.firstWhere(
      (item) => item.prodId == prodId,
    );
    _cartItems.remove(cartItem);
    notifyListeners();
  }

  get cartItemCount {
    return _cartItems.length;
  }

  get cartTotalPrice {
    totalPrice = 0.0;
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
