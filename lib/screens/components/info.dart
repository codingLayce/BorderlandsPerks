import 'package:flutter/material.dart';
import 'package:borderlands_perks/common/app_colors.dart' as app_colors;

class Info extends StatelessWidget {
  final String message;

  const Info({required this.message, Key? key}) : super(key: key);

  static SnackBar getSnackBar(BuildContext context, String message) {
    return SnackBar(content: Info(message: message));
  }

  @override
  Widget build(BuildContext context) {
    return Text(message,
        style: const TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: app_colors.textAttributColor));
  }
}
