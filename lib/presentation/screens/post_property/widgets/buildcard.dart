import 'package:flutter/material.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

Widget buildCard({required Widget child}) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.0)),
    elevation: 10,
    color: ColorsPalette.bgColor,
    margin: const EdgeInsets.only(bottom: 0.0),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: child,
    ),
  );
}
