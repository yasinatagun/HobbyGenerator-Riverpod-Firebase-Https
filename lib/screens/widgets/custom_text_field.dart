// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.inputType,
    required this.title,
    this.iconData,
    this.iconColor,
    this.obscureText = false,
  }) : super(key: key);
  final String hintText;
  final TextEditingController controller;
  final TextInputType inputType;
  final String title;
  final bool obscureText;
  final IconData? iconData;
  final Color? iconColor;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          obscureText: _obscureText,
          controller: widget.controller,
          keyboardType: widget.inputType,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.iconData != null ? Container(
              decoration: BoxDecoration(
              color: widget.iconColor == null ? Colors.grey : widget.iconColor!.withOpacity(0.1), // Background color
              border: Border.all(
                color: Colors.transparent, // Border color
                width: 1, // Border width
              ),
              borderRadius: BorderRadius.circular(10), // Border radius
            ),
            margin: const EdgeInsets.all(10), // Adjusts the space around the container within the prefix area
            padding: const EdgeInsets.all(10), // Adjusts the space around the icon inside the container
            child: 
              Icon(widget.iconData, color: widget.iconColor,size: 15,),
               // Icon color
            
            ) : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: _togglePasswordVisibility,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
