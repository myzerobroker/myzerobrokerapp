import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreen;
  final Widget tabletScreen;
  final Widget desktopScreen;

  const ResponsiveLayout({
    required this.mobileScreen,
    required this.tabletScreen,
    required this.desktopScreen,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return mobileScreen; // Mobile Layout
    } else if (width >= 600 && width < 1200) {
      return tabletScreen; // Tablet Layout
    } else {
      return desktopScreen; // Desktop Layout
    }
  }
}
