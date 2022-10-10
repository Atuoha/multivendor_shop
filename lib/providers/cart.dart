import 'package:flutter/material.dart';
import 'package:multivendor_shop/models/cart.dart';

class CartData extends ChangeNotifier {
  var totalPrice = 0.0;

  bool isItemOnCart(String id) {
    return _cartItems.any((item) => item.prodId == id);
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
    print('ITEM IS SUCCESSFULLY ADDED TO CART');
  }

  void removeFromCart(String prodId) {
    var cartItem = _cartItems.firstWhere(
      (item) => item.prodId == prodId,
    );
    _cartItems.remove(cartItem);
    notifyListeners();
    print('ITEM IS SUCCESSFULLY REMOVED FROM CART');
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
