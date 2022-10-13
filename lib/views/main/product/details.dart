import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multivendor_shop/components/loading.dart';
import 'package:multivendor_shop/models/cart.dart';
import 'package:multivendor_shop/views/main/store/store_details.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:photo_view/photo_view.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import '../../../providers/cart.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);
  final dynamic product;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with TickerProviderStateMixin {
  void showImageBottom() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) => SizedBox(
        height: 500,
        child: CarouselSlider.builder(
          itemCount: widget.product['images'].length,
          itemBuilder: (context, index, i) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '${index + 1}/${widget.product['images'].length}',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                  child: Image.network(
                    widget.product['images'][index],
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          options: CarouselOptions(
            viewportFraction: 1,
            aspectRatio: 1.5,
            height: 500,
            autoPlay: true,
          ),
        ),
      ),
    );
  }

  // toggle isFav
  void toggleIsFav(bool status, var id) {
    final db = FirebaseFirestore.instance.collection('products').doc(id);
    setState(() {
      db.update({'isFav': !status});
    });
  }

  DocumentSnapshot? store;

  _fetchStore() async {
    var details = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(widget.product['seller_id'])
        .get();
    setState(() {
      store = details;
    });
  }

  // navigate to store
  void navigateToStore() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StoreDetails(store: store),
      ),
    );
  }

  Animation<double>? _animation;
  AnimationController? _animationController;
  var isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 260),
      );

      final curvedAnimation = CurvedAnimation(
        curve: Curves.easeInOut,
        parent: _animationController!,
      );
      _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

      //  fetching store details
      _fetchStore();
    }
    setState(() {
      isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<CartData>(context, listen: false);
    var userId = FirebaseAuth.instance.currentUser!.uid;

    // add to cart
    void addToCart() {
      var product = widget.product;
      cartData.addToCart(
        CartItem(
          id: '',
          docId: product.id,
          prodId: product['prod_id'],
          userId: userId,
          sellerId: product['seller_id'],
          prodName: product['title'],
          prodPrice: double.parse(product['price']),
          prodImgUrl: product['images'][0],
          totalPrice: double.parse(product['price']),
        ),
      );
    }

    // remove from cart
    void removeFromCart() {
      cartData.removeFromCart(widget.product['prod_id']);
    }

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
        .where('category', isEqualTo: product['category'])
        .where('sub_category', isEqualTo: product['sub_category'])
        // .where('prod_id', isNotEqualTo: product['prod_id'])
        .snapshots();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: cartData.isItemOnCart(widget.product['prod_id'])
                ? "Remove from cart"
                : "Add to cart",
            iconColor: Colors.white,
            bubbleColor: primaryColor,
            icon: cartData.isItemOnCart(widget.product['prod_id'])
                ? Icons.shopping_cart
                : Icons.shopping_cart_outlined,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            onPress: () {
              if (cartData.isItemOnCart(widget.product['prod_id'])) {
                removeFromCart();
              } else {
                addToCart();
              }
              _animationController!.reverse();
            },
          ),
          Bubble(
            title: "Check store",
            iconColor: Colors.white,
            bubbleColor: primaryColor,
            icon: Icons.storefront,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            onPress: () {
              navigateToStore();
              _animationController!.reverse();
            },
          ),
        ],
        animation: _animation!,
        onPress: () => _animationController!.isCompleted
            ? _animationController!.reverse()
            : _animationController!.forward(),
        iconColor: Colors.white,
        iconData: Icons.add,
        backGroundColor: primaryColor,
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
      body: Consumer<CartData>(
        builder: (context, data, child) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => showImageBottom(),
                child: Container(
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
                    itemBuilder: (context, index) => PhotoView(
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      maxScale: 100.0,
                      imageProvider: NetworkImage(
                        product['images'][index],
                        // fit: BoxFit.cover,
                      ),
                    ),
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
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    product: data,
                                  ),
                                ),
                              ),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            data['images'][0],
                                            width: 173,
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: GestureDetector(
                                            onTap: () => toggleIsFav(
                                                data['isFav'], data.id),
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
      ),
    );
  }
}
