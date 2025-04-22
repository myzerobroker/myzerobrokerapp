import 'package:flutter/material.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

class Textfield extends StatelessWidget {
  final String? text;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Icon? icon;
  final String hintText;
  final String? Function(String?)? validator;

  final void Function(String)? onChanged;

  const Textfield({
    super.key,
    this.text,
    this.onChanged,
    required this.controller,
    this.icon,
    required this.textInputType,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      controller: controller,
      style: TextStyle(fontWeight: FontWeight.bold),
      keyboardType: textInputType,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.02,
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
        hintStyle: TextStyle(
          fontSize: width * 0.04,
          fontWeight: FontWeight.w500,
          color: ColorsPalette.primaryColor.withOpacity(0.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
