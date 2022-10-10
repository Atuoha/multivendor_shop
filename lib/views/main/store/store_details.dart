import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../utilities/products_stream_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StoreDetails extends StatefulWidget {
  const StoreDetails({
    Key? key,
    required this.store,
  }) : super(key: key);
  final dynamic store;

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  void placeCall() {
    // TODO: Implement placeCall
    if (kDebugMode) {
      print(widget.store['phone']);
    }
  }

  void sendMail() {
    // TODO: Implement sendMail
    if (kDebugMode) {
      print(widget.store['email']);
    }
  }

  void sendWhatsappMsg() {
    // TODO: Implement sendWhatsappMsg
    if (kDebugMode) {
      print('sendWhatsappMsg');
    }
  }

  @override
  Widget build(BuildContext context) {
    var store = widget.store;

    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('seller_id', isEqualTo: store.id)
        .snapshots();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomSheet: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => sendWhatsappMsg(),
                  icon: const FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Whatsapp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => placeCall(),
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Place call',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => sendMail(),
                  icon: const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Send mail',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.chevron_left,
                size: 35,
                color: primaryColor,
              ),
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18.0),
            child: Icon(
              Icons.storefront,
              color: primaryColor,
              size: 35,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height / 3,
              child: Image.network(
                store['image'],
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store['fullname'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  Text(store['address']),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 1,
              child: ProductStreamBuilder(
                productStream: productsStream,
              ),
            )
          ],
        ),
      ),
    );
  }
}
