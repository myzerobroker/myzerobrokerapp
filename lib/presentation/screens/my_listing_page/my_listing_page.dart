import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/my_listing/my_listing_bloc.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:shimmer/shimmer.dart';

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
                      return Center(
                        child: Container(
                          width: 500,
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              photos.isEmpty
                                  ? Image.asset(
                                      "assets/images/my_zero_broker_logo (2).png",
                                    )
                                  : Image.network(
                                      "https://myzerobroker.com/public/storage/" +
                                          photos[0].toString(),
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                              const Divider(color: Colors.black45),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 10,
                                runSpacing: 6,
                                children: [
                                  _detailRow(
                                    'Property No:',
                                    "RS" + property.id.toString(),
                                    Colors.blue,
                                  ),
                                  _detailRow(
                                    'Posted on:',
                                    "${DateTime.parse(property.createdAt.toString()).day}-"
                                        "${DateTime.parse(property.createdAt.toString()).month}-"
                                        "${DateTime.parse(property.createdAt.toString()).year}",
                                    Colors.red,
                                  ),
                                  _detailRow('Location:', loc, Colors.red),
                                  _detailRow(
                                      'Area:', area.toString(), Colors.red),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _detailRow(
                                'Plot Area:',
                                property.areaSqft?.toString() ?? "Not Defined",
                              ),
                              _detailRow(
                                'Built-Up Area:',
                                property.carpetAreaSqft?.toString() ??
                                    "Not Defined",
                              ),
                              _detailRow(
                                'Property Age:',
                                property.propertyAge?.toString() ?? "N/A",
                              ),
                              _detailRow(
                                'Floors:',
                                property.totalFloor?.toString() ?? "N/A",
                              ),
                              _detailRow(
                                'Facing:',
                                property.facing?.toString() ?? "N/A",
                              ),
                              _detailRow(
                                'Offer:',
                                "₹" + property.expectedPrice.toString(),
                                Colors.green,
                              ),
                              _detailRow(
                                'Maintenance:',
                                "₹" +
                                    (property.maintenanceCost?.toString() ??
                                        "N/A"),
                              ),
                              _detailRow(
                                'Furnishing:',
                                property.furnishing?.toString() ?? "N/A",
                              ),
                              _detailRow(
                                'Parking:',
                                property.parkingType?.toString() ?? "N/A",
                              ),
                              _detailRow(
                                'Kitchen Type:',
                                property.kitchenType?.toString() ?? "N/A",
                              ),
                              _detailRow(
                                'Bathrooms:',
                                property.bathroom?.toString() ?? "N/A",
                              ),
                              _detailRow(
                                'Balcony:',
                                property.balcony?.toString() ?? "N/A",
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'No extra amenities',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
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
