import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ActionListTile extends StatelessWidget {
  const ActionListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTapHandler,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTapHandler;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTapHandler ,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: Icon(
        icon,
        color: primaryColor,
      ),
    );
  }
}
