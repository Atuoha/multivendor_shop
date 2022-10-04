
import 'package:flutter/material.dart';

import '../constants/colors.dart';

// snackbar for error message
showSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: primaryColor,
      action: SnackBarAction(
        onPressed: () => Navigator.of(context).pop(),
        label: 'Dismiss',
        textColor: Colors.white,
      ),
    ),
  );
}