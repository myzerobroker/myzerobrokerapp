import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key, required this.images, });
  final List<dynamic> images;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController controller;
  Timer? autoScrollTimer;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);

    // Start the automatic scrolling
    autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (controller.hasClients) {
        setState(() {
          currentIndex = (currentIndex + 1) % widget.images.length;
        });
        controller.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer and dispose of the controller
    autoScrollTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          // Image Carousel
          SizedBox(
            height: 270,
            child: PageView.builder(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    "https://myzerobroker.com/public/storage/" +
                        widget.images[index].toString(),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return SizedBox(
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                );
              },
              itemCount: widget.images.length,
            ),
          ),
          // Smooth Page Indicator
          SmoothPageIndicator(
            controller: controller,
            count: widget.images.length,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              type: WormType.thinUnderground,
            ),
          ),
        ],
      ),
    );
  }
}
