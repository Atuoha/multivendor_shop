import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.chevron_left,
              size: 35,
              color: primaryColor,
            ),
          );
        }),
      ),
    );
  }
}
