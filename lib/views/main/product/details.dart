import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multivendor_shop/components/loading.dart';
import '../../../constants/colors.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);
  final dynamic product;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // toggle isFav
  void toggleIsFav(bool status, var id) {
    final db = FirebaseFirestore.instance.collection('products').doc(id);
    setState(() {
      db.update({'isFav': !status});
    });
  }

  // add to cart
  void addToCart() {
    // TODO: Implement add to cart
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: litePrimary,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.grey,
        statusBarBrightness: Brightness.dark,
      ),
    );

    var product = widget.product;
    final firestore = FirebaseFirestore.instance;

    final Stream<QuerySnapshot> similarProducts = firestore
        .collection('products')
        .where('sub_category', isEqualTo: product['sub_category'])
        .snapshots();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4,
        backgroundColor: primaryColor,
        onPressed: () => addToCart(),
        label: const Text(
          'Add to cart',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: const Icon(
          Icons.shopping_cart_outlined,
          color: Colors.white,
        ),
      ),
      extendBodyBehindAppBar: true,
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
                color: primaryColor,
                size: 35,
              ),
            );
          },
        ),
        actions: [
          GestureDetector(
            onTap: () => toggleIsFav(product['isFav'], product.id),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Icon(
                product['isFav'] ? Icons.favorite : Icons.favorite_border,
                color: Colors.redAccent,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height / 2,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Swiper(
                autoplay: true,
                pagination: const SwiperPagination(
                  builder: SwiperPagination.dots,
                ),
                itemCount: product['images'].length,
                itemBuilder: (context, index) => Image.network(
                  product['images'][index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'],
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Category: ',
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: product['category'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('${product['quantity']} available')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${product['price']}',
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product['description'],
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Similar Items You May Like',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 3.5,
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                stream: similarProducts,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Loading(
                        color: primaryColor,
                        kSize: 30,
                      ),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Column(
                      children: [
                        Image.asset(
                          'assets/images/sad.png',
                          width: 150,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'No similar products available!',
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        )
                      ],
                    );
                  }

                  return CarouselSlider.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index, i) {
                      var data = snapshot.data!.docs[index];
                      return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Stack(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        data['images'][0],
                                        width: 173,
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () =>
                                            toggleIsFav(data['isFav'], data.id),
                                        child: CircleAvatar(
                                          backgroundColor: litePrimary,
                                          child: Icon(
                                            data['isFav']
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: GestureDetector(
                                        onTap: () => addToCart(),
                                        child: CircleAvatar(
                                          backgroundColor: litePrimary,
                                          child: const Icon(
                                            Icons.shopping_cart_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data['title'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text('\$${data['price']}')
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ));
                    },
                    options: CarouselOptions(
                      viewportFraction: 0.5,
                      aspectRatio: 1.5,
                      height: size.height / 3.5,
                      autoPlay: true,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
