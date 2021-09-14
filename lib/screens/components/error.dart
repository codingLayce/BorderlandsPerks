import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String error;

  const Error({required this.error, Key? key}) : super(key: key);

  static SnackBar getSnackBar(BuildContext context, String error) {
    return SnackBar(
        action: SnackBarAction(
            label: "Close",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }),
        content: Error(error: error));
  }

  @override
  Widget build(BuildContext context) {
    return Text(error,
        style: const TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.red));
  }
}
