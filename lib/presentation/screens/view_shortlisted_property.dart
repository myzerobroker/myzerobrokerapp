import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/models/property_in_cities_model.dart';
import 'package:my_zero_broker/locator.dart';
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
                      return Center(
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(12),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
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
                              // Header: Logo & Title
                              photos.isEmpty
                                  ? Image.asset(
                                      "assets/images/my_zero_broker_logo (2).png")
                                  : Image.network(
                                      "https://myzerobroker.com/public/storage/" +
                                          photos[0].toString(),
                                      height: 300,
                                      width: double.infinity,
                                      fit: BoxFit.fitHeight,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                            child: CircularProgressIndicator());
                                      },
                                    ),
                              Divider(color: Colors.black45),
                              SizedBox(height: 6),
                              // Property Details
                              Wrap(
                                spacing: 10,
                                runSpacing: 6,
                                children: [
                                  Row(
                                    children: [
                                      FutureBuilder(
                                          future: checkIfStringexist(
                                              jsonEncode(property.toJson())),
                                          builder: (context, sp) {
                                            if (sp.hasData) {
                                              if (sp.data! == false) {
                                                return IconButton(
                                                  icon: Icon(
                                                      Icons.favorite_border),
                                                  onPressed: () async {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    final list =
                                                        prefs.getStringList(
                                                                "favList") ??
                                                            [];
                                                    list.add(jsonEncode(
                                                        property.toJson()));
                                                    prefs.setStringList(
                                                        "favList", list);
                                                    setState(() {});
                                                  },
                                                );
                                              } else {
                                                return IconButton(
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    final list =
                                                        prefs.getStringList(
                                                                "favList") ??
                                                            [];
                                                    list.remove(jsonEncode(
                                                        property.toJson()));
                                                    prefs.setStringList(
                                                        "favList", list);
                                                    setState(() {});
                                                  },
                                                );
                                              }
                                            } else {
                                              return Container();
                                            }
                                          })
                                    ],
                                  ),
                                  _detailRow(
                                      'Property No:',
                                      "RS" + property.id.toString(),
                                      Colors.blue),
                                  _detailRow(
                                      'Posted on:',
                                      DateTime.parse(
                                                  property.createdAt.toString())
                                              .day
                                              .toString() +
                                          "-" +
                                          DateTime.parse(
                                                  property.createdAt.toString())
                                              .month
                                              .toString() +
                                          "-" +
                                          DateTime.parse(
                                                  property.createdAt.toString())
                                              .year
                                              .toString(),
                                      Colors.red),
                                  _detailRow('Location:', loc, Colors.red),
                                  _detailRow(
                                      'Area:', area.toString(), Colors.red),
                                ],
                              ),
                              SizedBox(height: 10),
                              _detailRow(
                                  'Plot Area:',
                                  property.areaSqft.toString() == "null"
                                      ? "Not Defined"
                                      : (property.areaSqft.toString() +
                                          ' sqFT')),
                              _detailRow(
                                  'Built-Up Area:',
                                  property.carpetAreaSqft.toString() == "null"
                                      ? "Not Defined"
                                      : (property.carpetAreaSqft.toString() +
                                          ' sqFT')),
                              _detailRow('Property Age:',
                                  property.propertyAge.toString()),
                              _detailRow(
                                  'Floors:', property.totalFloor.toString()),
                              _detailRow('Facing:', property.facing.toString()),
                              _detailRow(
                                  'Offer:',
                                  "₹" + property.expectedPrice.toString(),
                                  Colors.green),
                              _detailRow('Maintainance:',
                                  '₹' + property.maintenanceCost.toString()),
                              _detailRow('Furnishing:',
                                  property.furnishing.toString()),
                              _detailRow(
                                  'Parking:', property.parkingType.toString()),
                              _detailRow('Kitchen Type:',
                                  property.kitchenType.toString()),
                              _detailRow(
                                  'Bathrooms:', property.bathroom.toString()),
                              _detailRow(
                                  'Balcony:', property.balcony.toString()),
                              SizedBox(height: 6),
                              Text(
                                'No extra amenities',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  // Action on press
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: Size(double.infinity, 40),
                                ),
                                child: Text('Get Owner Details'),
                              ),
                            ],
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
