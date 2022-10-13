import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../components/loading.dart';
import '../../../../components/search_box.dart';
import '../../../../constants/colors.dart';
import '../../../../utilities/products_stream_builder.dart';
import '../../product/details.dart';
import 'edit_product.dart';

class ManageProductsScreen extends StatefulWidget {
  static const routeName = '/manage_products';

  const ManageProductsScreen({Key? key}) : super(key: key);

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // remove product
    void removeProduct(String id) {
      firebase.collection('products').doc(id).delete();
    }

    Stream<QuerySnapshot> productStream = firebase
        .collection('products')
        .where('seller_id', isEqualTo: userId)
        .snapshots();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: litePrimary,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.grey,
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Manage Products',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 5,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
            child: StreamBuilder<QuerySnapshot>(
              stream: productStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error occurred ): '),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Loading(
                      color: primaryColor,
                      kSize: 30,
                    ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/sad.png',
                          width: 150,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'No data available!',
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        )
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data!.docs[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(product: item),
                        ),
                      ),
                      child: Dismissible(
                        onDismissed: (direction) => removeProduct(item.id),
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
                            title: Text('Remove ${item['title']}'),
                            content: Text(
                              'Are you sure you want to remove ${item['title']} from your products?',
                            ),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
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
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
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
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 35,
                              backgroundImage: NetworkImage(item['images'][0]),
                            ),
                            title: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text('\$${item['price']}'),
                            trailing: IconButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProduct(product: item),
                                ),
                              ),
                              icon: const Icon(
                                Icons.edit_note,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
