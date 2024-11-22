import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  final String? text;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Icon? icon;
  final String hintText;

  const Textfield({
    super.key,
    this.text,
    required this.controller,
    this.icon,
    required this.textInputType,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
 
    final width = MediaQuery.of(context).size.width;

    return TextField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(
            horizontal:width * 0.02, 
          ),
          child: Text(
            text ?? '',
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: width * 0.1,
        ),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
