import 'package:flutter/material.dart';

class BaseTileButton extends StatelessWidget {
  final String imagePath;
  const BaseTileButton({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16)),
        child: Container()
        // Image.asset(
        //   imagePath,
        //   height: 40,
        // ),
        );
  }
}
