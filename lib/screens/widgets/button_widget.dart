
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.onPressed,
    required this.buttonText
  });
  final VoidCallback onPressed;
  final String buttonText;
  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
              horizontal: 50, vertical: 20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15))),
      child: Text(buttonText, style: const TextStyle(color: Colors.white),),
    );
  }
}
