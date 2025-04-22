import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/my_listing/my_listing_bloc.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/image_carousel.dart';
// import 'package:my_zero_broker/utils/constant/colors.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';
import 'package:shimmer/shimmer.dart';

import '../view_property_in_city_page/property_detail_screen.dart';

class MyListingPage extends StatefulWidget {
  const MyListingPage({super.key});

  @override
  State<MyListingPage> createState() => _MyListingPageState();
}

class _MyListingPageState extends State<MyListingPage> {
  final locations = locator.get<AreaDetailsDependency>().cityDetails.map((e) {
    return {
      "label": e.cName,
      "icon": Icons.location_city,
      "id": e.id.toString()
    };
  }).toList();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MyListingBloc>(context).add(const FetchMyListing());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Listing'),
      ),
      body: BlocBuilder<MyListingBloc, MyListingState>(
        builder: (context, state) {
          if (state is MyListingLoading) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Shimmer for t
                    SizedBox(height: 30),
                    // Shimmer for buttons
                    for (int i = 0; i < 4; i++) ...[
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                    // Shimmer for dropdowns
                    for (int i = 0; i < 5; i++) ...[
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          } else if (state is MyListingLoaded) {
            return state.myListing.isEmpty
                ? const Center(
                    child: Text("No Shortlisted Property"),
                  )
                : ListView.builder(
                    itemCount: state.myListing.length,
                    itemBuilder: (context, index) {
                      final property = state.myListing[index];
                      final List photos = jsonDecode(property.photos!);
                      final loc = locations
                          .firstWhere((element) =>
                              element["id"] ==
                              property.cityId.toString())["label"]
                          .toString();
                      final areas =
                          locator.get<AreaDetailsDependency>().areas[loc];
                      final area = areas!.firstWhere((e) =>
                          e["id"].toString() ==
                          property.localityId.toString())["a_name"];
                      print(photos);
                      final propertySTATUS = property.property;
                      final purpose = property.purpose;
                      String heading;
                      if (propertySTATUS == "Residential" &&
                          purpose == "Sale/Resale") {
                        heading = "RS";
                      } else if (propertySTATUS == "Residential" &&
                          purpose == "Rent") {
                        heading = "RR";
                      } else if (propertySTATUS == "Commercial" &&
                          purpose == "Sale/Resale") {
                        heading = "CS";
                      } else if (propertySTATUS == "Commercial" &&
                          purpose == "Rent") {
                        heading = "CR";
                      } else if (propertySTATUS == "Residential" &&
                          purpose == "Sell") {
                        heading = "RS";
                      } else {
                        heading = "PR";
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PropertyDetailScreen(property: property),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ColorsPalette.cardBgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  ColorsPalette.primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
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
          } else if (state is MyListingError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

Widget _detailRow(String label, String value, [Color? color]) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: Text(
          label,
          style: const TextStyle(
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
