import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multivendor_shop/views/main/store/store_details.dart';
import '../../../components/loading.dart';
import '../../../constants/colors.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final Stream<QuerySnapshot> storeStream =
      FirebaseFirestore.instance.collection('sellers').snapshots();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 48.0),
      child: Column(
        children: [
          Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                Icon(
                  Icons.storefront_rounded,
                  color: primaryColor,
                ),
                Text(
                  'Stores',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 28,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: size.height / 1.25,
            child: StreamBuilder<QuerySnapshot>(
              stream: storeStream,
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
                  return Column(
                    children: [
                      Image.asset(
                        'assets/images/sad.png',
                        width: 150,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'No store available!',
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      )
                    ],
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 2,
                  ),
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StoreDetails(
                              store: data,
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Stack(
                            children: [
                              Card(
                                elevation: 1.5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(data['image']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                left: 5,
                                child: Text(
                                  data['fullname'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () => {},
                                  child: CircleAvatar(
                                    backgroundColor: litePrimary,
                                    child: const Icon(
                                      Icons.storefront,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
