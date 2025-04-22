import 'package:flutter/material.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorsPalette.primaryColor,
              ),
        ),
      ),
    );
  }
}
