import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../views/main/product/details.dart';

Dismissible buildCart(
  void Function(String prodId) removeFromCart,
  item,
  BuildContext context,
  void Function(String id) increaseQuantity,
  void Function(String id) reduceQuantity,
) {
  return Dismissible(
    onDismissed: (direction) => removeFromCart(item.prodId),
    direction: DismissDirection.endToStart,
    background: Container(
      height: 115,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red,
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(
        Icons.delete_forever,
        color: Colors.white,
        size: 40,
      ),
    ),
    confirmDismiss: (direction) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove ${item.prodName}'),
        content: Text(
          'Are you sure you want to remove ${item.prodName} from cart?',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
    key: ValueKey(item.id),
    child: Card(
      elevation: 3,
      child: GestureDetector(
        onTap: () async {
          await FirebaseFirestore.instance
              .collection('products')
              .doc(item.docId)
              .get()
              .then(
                (value) => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(product: value),
                  ),
                ),
              );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 5,
          ),
          leading: CircleAvatar(
            backgroundColor: primaryColor,
            backgroundImage: NetworkImage(item.prodImgUrl),
          ),
          title: Text(
            item.prodName,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('\$${item.totalPrice}'),
              const SizedBox(height: 5),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => increaseQuantity(item.id),
                    child: const Icon(
                      Icons.add,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item.quantity.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => reduceQuantity(item.id),
                    child: const Icon(
                      Icons.remove,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () => removeFromCart(item.prodId),
            icon: const Icon(
              Icons.delete_forever,
              color: primaryColor,
            ),
          ),
        ),
      ),
    ),
  );
}
