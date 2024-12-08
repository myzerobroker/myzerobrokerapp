// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Elevatedbutton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final double height;
  final double width;
  final Color? bgcolor;
  final Color? foregroundColor;

  const Elevatedbutton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.height,
    required this.width,
    this.bgcolor, this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double calFontSize = height * 0.03; 
    final double fontSize = calFontSize.clamp(14.0, 18.0); 

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgcolor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: EdgeInsets.symmetric(
          vertical: height * 0.02, 
          horizontal: width * 0.1,
        ),
        minimumSize: Size(width * 0.8, height * 0.07), 
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
