import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/models/property_in_cities_model.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/screens/view_property_in_city_page/property_detail_screen.dart';
import 'package:my_zero_broker/presentation/widgets/image_carousel.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewShortlistedProperty extends StatefulWidget {
  const ViewShortlistedProperty({super.key});

  @override
  State<ViewShortlistedProperty> createState() =>
      _ViewShortlistedPropertyState();
}

class _ViewShortlistedPropertyState extends State<ViewShortlistedProperty> {
  Future<List<Property>> _fetchShortlistedProperty() async {
    // Fetch shortlisted property
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final shortlistedProperty = prefs.getStringList('favList') ?? [];

    final properties = shortlistedProperty
        .map((e) => Property.fromJson(jsonDecode(e)))
        .toList();
    print(properties);
    return properties;
  }

  final locations = locator.get<AreaDetailsDependency>().cityDetails.map((e) {
    return {
      "label": e.cName,
      "icon": Icons.location_city,
      "id": e.id.toString()
    };
  }).toList();
  Future<bool> checkIfStringexist(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList("favList") ?? [];
    if (list.contains(s)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Shortlisted Property'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Property>>(
        future: _fetchShortlistedProperty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            final properties = snapshot.data;

            return properties!.length == 0
                ? Center(
                    child: Text("No Shortlisted Property"),
                  )
                : ListView.builder(
                    itemCount: properties!.length,
                    itemBuilder: (context, index) {
                      final property = properties[index];
                      final List photos = jsonDecode(property.photos!);
                      final loc = locations
                          .firstWhere((element) =>
                              element["id"] ==
                              property.cityId.toString())["label"]
                          .toString();
                      final areas =
                          locator.get<AreaDetailsDependency>().areas[loc];
                      final area = areas!
                          .where((e) =>
                              e["id"].toString() ==
                              property.localityId.toString())
                          .toList()
                          .first["a_name"];
                      print(areas);
                      print(area);
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ColorsPalette.cardBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: ColorsPalette.primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PropertyDetailScreen(property: property),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Card(
                              color: ColorsPalette.cardBgColor,
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  photos.isEmpty
                                      ? Image.asset(
                                          "assets/images/my_zero_broker_logo (2).png",
                                          height: 200,
                                          fit: BoxFit.cover)
                                      : photos.length > 1
                                          ? ImageCarousel(
                                              images: photos,
                                            )
                                          : Image.network(
                                              "https://myzerobroker.com/public/storage/" +
                                                  photos[0].toString(),
                                              height: 200,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              },
                                            ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          loc + ", " + area,
                                          style: TextStyles.bodyStyle.copyWith(
                                              color: ColorsPalette
                                                  .textSecondaryColor),
                                        ),
                                        Text(
                                          property.status == 'Rent'
                                              ? 'Rent: ${formatPrice(property.expectedRent.toString())}'
                                              : 'Price: ${formatPrice(property.expectedPrice.toString())}',
                                          style: TextStyles.priceStyle,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: ColorsPalette.starColor,
                                                size: 16),
                                            Text("4.5",
                                                style: TextStyles.bodyStyle),
                                            Text(" For ${property.status}",
                                                style: TextStyles.bodyStyle),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }
          return const Center(
            child: Text('No shortlisted property'),
          );
        },
      ),
    );
  }
}

String formatPrice(String price) {
  try {
    double priceValue = double.parse(price);
    String formattedPrice;

    if (priceValue >= 10000000) {
      formattedPrice =
          (priceValue / 10000000).toStringAsFixed(1).replaceAll('.0', '') +
              ' Cr';
    } else if (priceValue >= 100000) {
      formattedPrice =
          (priceValue / 100000).toStringAsFixed(1).replaceAll('.0', '') +
              ' Lakh';
    } else if (priceValue >= 1000) {
      formattedPrice =
          (priceValue / 1000).toStringAsFixed(1).replaceAll('.0', '') + ' K';
    } else {
      formattedPrice = priceValue.toStringAsFixed(0);
    }

    return '₹$formattedPrice (Negotiable)';
  } catch (e) {
    return '₹$price (Negotiable)';
  }
}

Widget _detailRow(String label, String value, [Color? color]) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color ?? Colors.black54,
          ),
        ),
      ),
    ],
  );
}
