import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20), 
        Image.asset(
          'assets/images/my_zero_broker_logo (2).png', 
          height: 80,
        ),
        SizedBox(height: 10),
      
      ],
    );
  }
}
