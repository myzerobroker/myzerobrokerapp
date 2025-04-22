import 'package:flutter/material.dart';

import '../../../utils/constant/colors.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/my_zero_broker_logo (2).png',
                height: 80,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ],
    );
  }
}
