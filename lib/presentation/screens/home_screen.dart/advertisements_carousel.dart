import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_zero_broker/utils/helpers/advertisements_service.dart';

class AdvertisementsCarousel extends StatefulWidget {
  @override
  _AdvertisementsCarouselState createState() => _AdvertisementsCarouselState();
}

class _AdvertisementsCarouselState extends State<AdvertisementsCarousel> {
  final AdvertisementService _advertisementService = AdvertisementService();
  List<String> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdvertisements();
  }

  Future<void> _loadAdvertisements() async {
    final images = await _advertisementService.fetchAdvertisements();
    setState(() {
      _images = images.map((url) {
        // Add the required prefix to all image URLs
        return 'https://myzerobroker.com/public/storage/$url';
      }).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_images.isEmpty) {
      return Center(
        child: Text(
          'No advertisements available',
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: _images.map((imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color.fromARGB(255, 87, 5, 5),// Border color
                  width: 2.0,              // Border width
                ),
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0), // Clip image to rounded corners
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 50.0,
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
