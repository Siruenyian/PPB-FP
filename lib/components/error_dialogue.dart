import 'package:flutter/material.dart';

class ErrorMessageDialog extends StatelessWidget {
  final String message;

  const ErrorMessageDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorMessageDialog(message: message);
      },
    );
  }
}
