class CartItem {
  final String id;
  final dynamic docId;
  final String sellerId;
  final String userId;
  final String prodId;
  final String prodName;
  final String prodImgUrl;
  final double prodPrice;
  double totalPrice;
  int quantity;

  CartItem({
    required this.id,
    required this.docId,
    required this.sellerId,
    required this.userId,
    required this.prodId,
    required this.prodName,
    required this.prodPrice,
    required this.prodImgUrl,
    this.quantity = 1,
    required this.totalPrice,
  });

  incrementQuantity() {
    quantity += 1;
    totalPrice += prodPrice;
  }

  decrementQuantity() {
    quantity -= 1;
    totalPrice -= prodPrice;
  }
}
