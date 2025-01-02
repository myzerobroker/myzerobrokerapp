import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_zero_broker/utils/helpers/advertisements_service.dart';
import 'package:shimmer/shimmer.dart';

class AdvertisementsCarousel extends StatefulWidget {
  @override
  _AdvertisementsCarouselState createState() => _AdvertisementsCarouselState();
}

class _AdvertisementsCarouselState extends State<AdvertisementsCarousel> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AdvertisementService().fetchAdvertisements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 100,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Container();
          } else {
            final images = snapshot.data as List<String>;
            if (images.isEmpty) {
              return Container();
            } else {
              return CarouselSlider.builder(
                itemCount: images.length,
                itemBuilder: (context, index, realIndex) {
                  // print(images[index])
                  final url = "https://myzerobroker.com/public/storage/" +
                      images[index];
                  return Container(
                    constraints: BoxConstraints(
                        minHeight: 200,
                        minWidth: 400,
                        maxWidth: 500,
                        maxHeight: 200),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  );
                },
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                ),
              );
            }
          }
        });
  }
}
