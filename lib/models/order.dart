class Order {
  final String id;
  final String prodId;
  final String prodName;
  final String prodImg;
  final int quantity;
  final int price;

  Order({
    required this.id,
    required this.prodId,
    required this.prodName,
    required this.prodImg,
    required this.quantity,
    required this.price,
  });
}
