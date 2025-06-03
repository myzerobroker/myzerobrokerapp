import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/models/property_in_cities_model.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/image_carousel.dart';
import 'package:my_zero_broker/utils/code_generator.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PropertyDetailScreen extends StatefulWidget {
  final Property property;
  final String? peropertyStatus;
  const PropertyDetailScreen({super.key, required this.property, this.peropertyStatus});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  Future<bool> checkIfStringexist(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList("favList") ?? [];
    return list.contains(s);
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

  @override
  Widget build(BuildContext context) {
    final List photos = jsonDecode(widget.property.photos!);
    final city = locator.get<AreaDetailsDependency>().cityDetails.firstWhere(
        (element) =>
            element.id.toString() == widget.property.cityId.toString());
    final loc = city.cName;
    final areas = locator.get<AreaDetailsDependency>().areas[loc];
    final area = areas!
        .where(
            (e) => e["id"].toString() == widget.property.localityId.toString())
        .toList()
        .first["a_name"];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorsPalette.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Property Details", style: TextStyles.subHeadingStyle),
        backgroundColor: ColorsPalette.appBarColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorsPalette.bgColor, ColorsPalette.secondaryColor],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: ColorsPalette.cardBgColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    photos.isEmpty
                        ? Image.asset(
                            "assets/images/my_zero_broker_logo (2).png",
                            height: 250,
                            fit: BoxFit.cover)
                        : photos.length > 1
                            ? ImageCarousel(images: photos)
                            : Image.network(
                                "https://myzerobroker.com/public/storage/" +
                                    photos[0].toString(),
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(loc + ", " + area,
                            style: TextStyles.bodyStyle.copyWith(
                                color: ColorsPalette.textSecondaryColor)),
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: ColorsPalette.starColor, size: 16),
                            Text("4.5", style: TextStyles.bodyStyle),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      widget.peropertyStatus == 'Rent'
                          ? 'Rent: ${formatPrice(widget.property.expectedRent.toString())}'
                          : 'Price: ${formatPrice(widget.property.expectedPrice.toString())}',
                      style: TextStyles.priceStyle,
                    ),
                    SizedBox(height: 16),
                    _detailRow(
                        'Property No:',
                        codeGenerator(widget.property.status,
                                widget.property.propertyType) +
                            widget.property.id.toString(),
                        ColorsPalette.primaryColor),
                    if (widget.property.propertyType != null &&
                        widget.property.propertyType!.isNotEmpty)
                      _detailRow(
                          'Property Type:',
                          widget.property.propertyType!,
                          ColorsPalette.primaryColor),
                    if (widget.property.createdAt != null)
                      _detailRow(
                          'Posted on:',
                          DateTime.parse(widget.property.createdAt.toString())
                              .toString()
                              .split(' ')[0],
                          ColorsPalette.primaryColor),
                    if (area != null && area.isNotEmpty)
                      _detailRow('Area:', area, ColorsPalette.primaryColor),
                    if (widget.property.bhk != null &&
                        widget.property.bhk!.isNotEmpty)
                      _detailRow('BHK:', widget.property.bhk!),
                    if (widget.property.areaSqft != null &&
                        widget.property.areaSqft.toString() != "null")
                      _detailRow(
                          'Plot Area:',
                          widget.property.areaSqft.toString() == "null"
                              ? "Not Defined"
                              : (widget.property.areaSqft.toString() +
                                  ' sqFT')),
                    if (widget.property.carpetAreaSqft != null &&
                        widget.property.carpetAreaSqft.toString() != "null")
                      _detailRow(
                          'Built-Up Area:',
                          widget.property.carpetAreaSqft.toString() == "null"
                              ? "Not Defined"
                              : (widget.property.carpetAreaSqft.toString() +
                                  ' sqFT')),
                    if (widget.property.propertyAge != null &&
                        widget.property.propertyAge!.isNotEmpty)
                      _detailRow('Property Age:', widget.property.propertyAge!),
                    if (widget.property.totalFloor != null &&
                        widget.property.totalFloor!.isNotEmpty)
                      _detailRow('Floors:', widget.property.totalFloor!),
                    if (widget.property.facing != null &&
                        widget.property.facing!.isNotEmpty)
                      _detailRow('Facing:', widget.property.facing!),
                    if (widget.property.expectedPrice != 0 ||
                        widget.property.expectedRent != 0 ||
                        widget.property.expectedPrice != null ||
                        widget.property.expectedRent != null)
                      _detailRow(
                        widget.peropertyStatus == 'Rent' ? "Rent:" : "Offer:",
                        widget.peropertyStatus == 'Rent'
                            ? formatPrice(
                                widget.property.expectedRent.toString())
                            : widget.property.property == "Plot"
                                ? formatPrice(widget.property.expectedPrice
                                            .toString())
                                        .replaceAll(' (Negotiable)', '') +
                                    ' per guntha (Negotiable)'
                                : formatPrice(
                                    widget.property.expectedPrice.toString()),
                        ColorsPalette.primaryColor,
                      ),
                    if (widget.property.maintenanceCost != null)
                      _detailRow('Maintenance:',
                          '₹' + widget.property.maintenanceCost.toString()),
                    if (widget.property.furnishing != null &&
                        widget.property.furnishing!.isNotEmpty)
                      _detailRow('Furnishing:', widget.property.furnishing!),
                    if (widget.property.parkingType != null &&
                        widget.property.parkingType!.isNotEmpty)
                      _detailRow('Parking:', widget.property.parkingType!),
                    if (widget.property.kitchenType != null &&
                        widget.property.kitchenType!.isNotEmpty)
                      _detailRow('Kitchen Type:', widget.property.kitchenType!),
                    if (widget.property.bathroom != null &&
                        widget.property.bathroom!.isNotEmpty)
                      _detailRow('Bathrooms:', widget.property.bathroom!),
                    if (widget.property.balcony != null &&
                        widget.property.balcony!.isNotEmpty)
                      _detailRow('Balcony:', widget.property.balcony!),
                    if (widget.property.property == "Plot")
                      _detailRow('Plot Depth:',
                          widget.property.plotDepth.toString() + " m"),
                    if (widget.property.property == "Plot")
                      _detailRow('Plot Front:',
                          widget.property.plotFront.toString() + " m"),
                    if (widget.property.property == "Plot")
                      _detailRow('Front Road:',
                          widget.property.frontRoad.toString() + " m"),
                    if (widget.property.property == "Plot")
                      _detailRow('Side Road:',
                          widget.property.sideRoad.toString() + " m"),
                    if (widget.property.property != "Plot")
                      _buildAmenitiesSection(widget.property),
                    SizedBox(height: 16),
                    if (widget.property.description != null &&
                        widget.property.description!.isNotEmpty)
                      Text(widget.property.description ?? "",
                          style: TextStyles.bodyStyle.copyWith(
                              fontStyle: FontStyle.italic,
                              color: ColorsPalette.textSecondaryColor)),
                    SizedBox(height: 16),
                    FutureBuilder<bool>(
                      future: checkIfStringexist(
                          jsonEncode(widget.property.toJson())),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        }
                        if (snapshot.hasData) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String? token = prefs.getString("authToken");

                                    if (token == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Please log in to get owner details")),
                                      );
                                      return;
                                    }

                                    Map<String, dynamic> payload = {
                                      "property_id": widget.property.id,
                                    };

                                    try {
                                      final response = await http.post(
                                        Uri.parse(
                                            'https://myzerobroker.com/api/get-owner-details'),
                                        headers: {
                                          'Content-Type': 'application/json',
                                          'Accept': 'application/json',
                                          'Authorization': 'Bearer $token',
                                        },
                                        body: jsonEncode(payload),
                                      );

                                      if (response.statusCode == 200) {
                                        var responseData = jsonDecode(response.body);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(responseData['message'] ??
                                                  "Details fetched successfully")),
                                        );
                                      } else {
                                        var responseData = jsonDecode(response.body);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(responseData['message'] ??
                                                  "Failed to fetch owner details")),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Error: $e")),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize: Size(0, 40), // Adjusted size
                                  ),
                                  child: Text('Get Owner Details'),
                                ),
                              ),
                              SizedBox(width: 16), // Add spacing between button and icon
                              IconButton(
                                icon: Icon(
                                  snapshot.data!
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: snapshot.data!
                                      ? Colors.red
                                      : ColorsPalette.iconColor,
                                ),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  final list =
                                      prefs.getStringList("favList") ?? [];
                                  if (snapshot.data!) {
                                    list.remove(
                                        jsonEncode(widget.property.toJson()));
                                  } else {
                                    list.add(
                                        jsonEncode(widget.property.toJson()));
                                  }
                                  prefs.setStringList("favList", list);
                                  setState(() {});
                                },
                              ),
                            ],
                          );
                        }
                        return Center(child: Text("No data available"));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label,
                style: TextStyles.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorsPalette.textPrimaryColor)),
          ),
          Expanded(
            flex: 3,
            child: Text(value,
                style: TextStyles.bodyStyle.copyWith(
                    color: color ?? ColorsPalette.textSecondaryColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(Property property) {
    final Map<String, String> amenitiesLabels = {
      "lift": "Lift",
      "internet_service": "Internet Service",
      "air_conditioner": "Air Conditioner",
      "club_house": "Club House",
      "intercom": "Intercom",
      "swimming_pool": "Swimming Pool",
      "childrens_play_area": "Children's Play Area",
      "fire_safety": "Fire Safety",
      "servant_room": "Servant Room",
      "shopping_center": "Shopping Center",
      "gas_pipeline": "Gas Pipeline",
      "park": "Park",
      "rain_water_harvesting": "Rain Water Harvesting",
      "sewage_treatment": "Sewage Treatment",
      "house_keeping": "House Keeping",
      "power_backup": "Power Backup",
      "visitor_parking": "Visitor Parking",
    };

    final availableAmenities = amenitiesLabels.entries
        .where((entry) => property.toJson()[entry.key] == 1)
        .map((entry) => entry.value)
        .toList();

    if (availableAmenities.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amenities:',
            style: TextStyles.bodyStyle.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: availableAmenities.map((amenity) {
            return Chip(
              label: Text(amenity, style: TextStyles.bodyStyle),
              backgroundColor: ColorsPalette.secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            );
          }).toList(),
        ),
      ],
    );
  }
}