import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_zero_broker/bloc/search_property/search_property_bloc.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/models/property_in_cities_model.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/image_carousel.dart';
import 'package:my_zero_broker/utils/code_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProperties extends StatefulWidget {
  const ViewProperties({
    super.key,
    required this.city_id,
    required this.status,
    required this.bhk,
    required this.area,
    required this.propertyType,
    required this.priceRange,
    required this.tp,
  });
  final String city_id;
  final String tp;
  final String status;
  final area;
  final String bhk;
  final String propertyType;
  final String priceRange;

  @override
  State<ViewProperties> createState() => _ViewPropertiesState();
}

class _ViewPropertiesState extends State<ViewProperties> {
  final cityDetails = locator.get<AreaDetailsDependency>().cityDetails.map((e) {
    return {
      "label": e.cName,
      "icon": Icons.location_city,
      "id": e.id.toString()
    };
  }).toList();
  int current = 1;
  Future<bool> checkIfStringexist(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList("favList") ?? [];
    if (list.contains(s)) {
      return true;
    }
    return false;
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

      return '₹$formattedPrice ';
    } catch (e) {
      return '₹$price (Negotiable)';
    }
  }

  bool show = false;
  List<dynamic> areas = [];
  late String selectedArea;
  List<Property> props = [];

  @override
  void initState() {
    super.initState();
    print(widget.status);
    BlocProvider.of<SearchPropertyBloc>(context).add(SearchBuyProperty(
        city_id: widget.city_id,
        area_id: widget.area ?? "0",
        page: current,
        tp: widget.tp,
        bhk: widget.bhk,
        priceRange: widget.priceRange,
        property_type: widget.propertyType,
        status: widget.status));
    areas = locator
        .get<AreaDetailsDependency>()
        .areas[cityDetails
            .firstWhere((element) => element["id"] == widget.city_id)["label"]]!
        .map((e) => e["a_name"])
        .toList();
    areas.add("Select Area");
    final city = cityDetails
        .firstWhere((element) => element["id"] == widget.city_id)["label"];
    print(city);
    final areaMap = locator.get<AreaDetailsDependency>().areas[city]
        as List<Map<String, dynamic>>;
    print(areaMap);

    selectedArea = widget.area == ""
        ? "Select Area"
        : areaMap.firstWhere((element) =>
            element["id"].toString() == widget.area.toString())["a_name"];
  }

  void animatetoIndex(int index, PageController controller) {
    controller.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.area);
    print(widget.tp);
    print(widget.status);
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Properties in ${cityDetails.firstWhere((element) => element["id"] == widget.city_id)["label"]}"),
        ),
        body: BlocBuilder<SearchPropertyBloc, SearchPropertyState>(
          builder: (context, state) {
            if (state is SearchPropertyLoaded) {
              props = state.properties.properties!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Total Pages"),
                        ],
                      ),
                      SizedBox(
                        height: 70,
                        child: Center(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.properties.pagination!.lastPage,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    current = index + 1;
                                  });

                                  BlocProvider.of<SearchPropertyBloc>(context)
                                      .add(SearchBuyProperty(
                                          city_id: widget.city_id,
                                          tp: widget.tp,
                                          area_id: selectedArea == "Select Area"
                                              ? "0"
                                              : locator
                                                  .get<AreaDetailsDependency>()
                                                  .areas[cityDetails.firstWhere(
                                                          (element) =>
                                                              element["id"] ==
                                                              widget.city_id)[
                                                      "label"]]!
                                                  .firstWhere((e) =>
                                                      e["a_name"] ==
                                                      selectedArea)["id"]
                                                  .toString(),
                                          page: current,
                                          bhk: widget.bhk,
                                          priceRange: widget.priceRange,
                                          property_type: widget.propertyType,
                                          status: widget.status));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 50,
                                  margin: EdgeInsets.only(
                                      right: 10, top: 10, bottom: 10),
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                        color: current == index + 1
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  decoration: BoxDecoration(
                                      color: current == index + 1
                                          ? Colors.red
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: current == index + 1
                                              ? Colors.red
                                              : Colors.grey.shade200)),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text("Filter Options"),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedArea,
                                hint: Row(
                                  children: [
                                    const Icon(Icons.map),
                                    const SizedBox(width: 10),
                                    const Text("Filter Area"),
                                  ],
                                ),
                                items: areas.map((e) {
                                  return DropdownMenuItem<String>(
                                    value: e,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.map,
                                            color: Colors.red),
                                        const SizedBox(width: 8),
                                        Text(e),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedArea = val!;
                                    show = true;

                                    final areaId = locator
                                        .get<AreaDetailsDependency>()
                                        .areas[cityDetails.firstWhere(
                                            (element) =>
                                                element["id"] ==
                                                widget.city_id)["label"]]!
                                        .firstWhere(
                                            (e) => e["a_name"] == val)["id"]
                                        .toString();

                                    BlocProvider.of<SearchPropertyBloc>(context)
                                        .add(SearchBuyProperty(
                                            city_id: widget.city_id,
                                            tp: widget.tp,
                                            area_id: areaId,
                                            bhk: widget.bhk,
                                            page: current,
                                            priceRange: widget.priceRange,
                                            property_type: widget.propertyType,
                                            status: widget.status));

                                    print(
                                        "Filtered Properties Count: ${props.length}");
                                  });
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: show && selectedArea != "Select Area",
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedArea = "Select Area";
                                  show = false;

                                  BlocProvider.of<SearchPropertyBloc>(context)
                                      .add(SearchBuyProperty(
                                          tp: widget.tp,
                                          city_id: widget.city_id,
                                          area_id: "0",
                                          bhk: widget.bhk,
                                          priceRange: widget.priceRange,
                                          property_type: widget.propertyType,
                                          page: current,
                                          status: widget.status));
                                  print(
                                      "Reset Properties Count: ${props.length}");
                                });
                              },
                              child: const Text("Remove Filter"),
                            ),
                          ),
                        ],
                      ),
                      state.properties.properties!.isEmpty
                          ? Center(
                              child: Text("No Results Found"),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: props.length,
                              itemBuilder: (context, index) {
                                final property = props[index];
                                final List photos =
                                    jsonDecode(props[index].photos!);

                                final loc = cityDetails
                                    .firstWhere((element) =>
                                        element["id"] ==
                                        property.cityId.toString())["label"]
                                    .toString();
                                final areas = locator
                                    .get<AreaDetailsDependency>()
                                    .areas[loc];
                                final area = areas!
                                    .where((e) =>
                                        e["id"].toString() ==
                                        property.localityId.toString())
                                    .toList()
                                    .first["a_name"];
                                print(property.toJson());
                                return Center(
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(vertical: 12),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        photos.isEmpty
                                            ? Image.asset(
                                                "assets/images/my_zero_broker_logo (2).png")
                                            : photos.length > 1
                                                ? ImageCarousel(images: photos)
                                                : Image.network(
                                                    "https://myzerobroker.com/public/storage/" +
                                                        photos[0].toString(),
                                                    height: 300,
                                                    width: double.infinity,
                                                    fit: BoxFit.fitHeight,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return SizedBox(
                                                        height: 300,
                                                        child: Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                      );
                                                    },
                                                  ),
                                        Divider(color: Colors.black45),
                                        SizedBox(height: 6),
                                        Wrap(
                                          spacing: 10,
                                          runSpacing: 6,
                                          children: [
                                            Row(
                                              children: [
                                                FutureBuilder(
                                                    future: checkIfStringexist(
                                                        jsonEncode(
                                                            property.toJson())),
                                                    builder: (context, sp) {
                                                      if (sp.hasData) {
                                                        if (sp.data! == false) {
                                                          return IconButton(
                                                            icon: Icon(Icons
                                                                .favorite_border),
                                                            onPressed:
                                                                () async {
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              final list = prefs
                                                                      .getStringList(
                                                                          "favList") ??
                                                                  [];
                                                              list.add(jsonEncode(
                                                                  property
                                                                      .toJson()));
                                                              prefs
                                                                  .setStringList(
                                                                      "favList",
                                                                      list);
                                                              setState(() {});
                                                            },
                                                          );
                                                        } else {
                                                          return IconButton(
                                                            icon: Icon(
                                                              Icons.favorite,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              final list = prefs
                                                                      .getStringList(
                                                                          "favList") ??
                                                                  [];
                                                              list.remove(
                                                                  jsonEncode(
                                                                      property
                                                                          .toJson()));
                                                              prefs
                                                                  .setStringList(
                                                                      "favList",
                                                                      list);
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
                                                codeGenerator(widget.status,
                                                        widget.tp) +
                                                    property.id.toString(),
                                                Colors.blue),
                                            if (property.propertyType != null &&
                                                property
                                                    .propertyType.isNotEmpty)
                                              _detailRow(
                                                  'Property Type:',
                                                  property.propertyType,
                                                  Colors.blue),
                                            if (property.createdAt != null)
                                              _detailRow(
                                                  'Posted on:',
                                                  DateTime.parse(property
                                                              .createdAt
                                                              .toString())
                                                          .day
                                                          .toString() +
                                                      "-" +
                                                      DateTime.parse(property
                                                              .createdAt
                                                              .toString())
                                                          .month
                                                          .toString() +
                                                      "-" +
                                                      DateTime.parse(property
                                                              .createdAt
                                                              .toString())
                                                          .year
                                                          .toString(),
                                                  Colors.red),
                                            if (state.properties.cityName !=
                                                    null &&
                                                state.properties.cityName!
                                                    .isNotEmpty)
                                              _detailRow(
                                                  'Location:',
                                                  state.properties.cityName
                                                      .toString(),
                                                  Colors.red),
                                            if (area != null && area.isNotEmpty)
                                              _detailRow('Area :',
                                                  area.toString(), Colors.red),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        if (property.bhk != null &&
                                            property.bhk!.isNotEmpty)
                                          _detailRow(
                                              "BHK", property.bhk.toString()),
                                        if (property.areaSqft != null &&
                                            property.areaSqft.toString() !=
                                                "null")
                                          _detailRow(
                                              'Plot Area:',
                                              property.areaSqft.toString() ==
                                                      "null"
                                                  ? "Not Defined"
                                                  : (property.areaSqft
                                                          .toString() +
                                                      ' sqFT')),
                                        if (property.carpetAreaSqft != null &&
                                            property.carpetAreaSqft
                                                    .toString() !=
                                                "null")
                                          _detailRow(
                                              'Built-Up Area:',
                                              property.carpetAreaSqft
                                                          .toString() ==
                                                      "null"
                                                  ? "Not Defined"
                                                  : (property.carpetAreaSqft
                                                          .toString() +
                                                      ' sqFT')),
                                        if (property.propertyAge != null &&
                                            property.propertyAge!.isNotEmpty)
                                          _detailRow('Property Age:',
                                              property.propertyAge.toString()),
                                        if (property.totalFloor != null &&
                                            property.totalFloor!.isNotEmpty)
                                          _detailRow('Floors:',
                                              property.totalFloor.toString()),
                                        if (property.facing != null &&
                                            property.facing!.isNotEmpty)
                                          _detailRow('Facing:',
                                              property.facing.toString()),
                                        if (property.expectedPrice != 0)
                                          _detailRow(
                                              widget.status == 'Rent'
                                                  ? "Rent: "
                                                  : 'Offer:',
                                              widget.status == 'Rent'
                                                  ? formatPrice(property
                                                      .expectedRent
                                                      .toString())
                                                  : formatPrice(property
                                                          .expectedPrice
                                                          .toString()) +
                                                      " " +
                                                      (property.property ==
                                                              "Plot"
                                                          ? "per guntha"
                                                          : "(Negotiable)"),
                                              Colors.green),
                                        if (property.maintenanceCost != null)
                                          _detailRow(
                                              'Maintainance:',
                                              '₹' +
                                                  property.maintenanceCost
                                                      .toString()),
                                        if (property.furnishing != null &&
                                            property.furnishing!.isNotEmpty)
                                          _detailRow('Furnishing:',
                                              property.furnishing.toString()),
                                        if (property.parkingType != null &&
                                            property.parkingType!.isNotEmpty)
                                          _detailRow('Parking:',
                                              property.parkingType.toString()),
                                        if (property.kitchenType != null &&
                                            property.kitchenType!.isNotEmpty)
                                          _detailRow('Kitchen Type:',
                                              property.kitchenType.toString()),
                                        if (property.bathroom != null &&
                                            property.bathroom!.isNotEmpty)
                                          _detailRow('Bathrooms:',
                                              property.bathroom.toString()),
                                        if (property.balcony != null &&
                                            property.balcony!.isNotEmpty)
                                          _detailRow('Balcony:',
                                              property.balcony.toString()),
                                        if (property.property == "Plot")
                                          _detailRow(
                                              "Plot Depth: ",
                                              property.plotDepth.toString() +
                                                  " m"),
                                        if (property.property == "Plot")
                                          _detailRow(
                                              "Plot Front:",
                                              property.plotFront.toString() +
                                                  " m"),
                                        if (property.property == "Plot")
                                          _detailRow(
                                              "Front Road: ",
                                              property.frontRoad.toString() +
                                                  " m"),
                                        if (property.property == "Plot")
                                          _detailRow(
                                              "Side Road: ",
                                              property.sideRoad.toString() +
                                                  " m"),
                                        if (property.property != "Plot")
                                          _buildAmenitiesSection(property),
                                        SizedBox(height: 6),
                                        if (property.description != null &&
                                            property.description!.isNotEmpty)
                                          Text(
                                            property.description ?? "",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        SizedBox(height: 12),
                                      ElevatedButton(
  onPressed: () async {
    // Fetch the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("authToken");

    if (token == null) {
      // Handle the case where the token is not found (e.g., user not logged in)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to get owner details")),
      );
      return;
    }

    // Prepare the payload and headers for the API call
    Map<String, dynamic> payload = {
      "property_id": property.id,
    };

    try {
      final response = await http.post(
        Uri.parse('https://myzerobroker.com/api/get-owner-details'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Add Bearer token to the header
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // Handle the successful response (e.g., show owner details)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Details fetched successfully")),
        );
      } else {
        // Handle error response
        var responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Failed to fetch owner details")),
        );
      }
    } catch (e) {
      // Handle any errors during the API call
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
    minimumSize: Size(double.infinity, 40),
  ),
  child: Text('Get Owner Details'),
),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      GestureDetector(
                        onTap: current < state.properties.pagination!.lastPage
                            ? () {
                                setState(() {
                                  current += 1;
                                });

                                BlocProvider.of<SearchPropertyBloc>(context)
                                    .add(SearchBuyProperty(
                                        city_id: widget.city_id,
                                        tp: widget.tp,
                                        area_id: selectedArea == "Select Area"
                                            ? "0"
                                            : locator
                                                .get<AreaDetailsDependency>()
                                                .areas[cityDetails.firstWhere(
                                                    (element) =>
                                                        element["id"] ==
                                                        widget
                                                            .city_id)["label"]]!
                                                .firstWhere((e) =>
                                                    e["a_name"] ==
                                                    selectedArea)["id"]
                                                .toString(),
                                        page: current,
                                        bhk: widget.bhk,
                                        priceRange: widget.priceRange,
                                        property_type: widget.propertyType,
                                        status: widget.status));
                              }
                            : null,
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: double.infinity,
                          margin:
                              EdgeInsets.only(right: 10, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color:
                                current < state.properties.pagination!.lastPage
                                    ? Colors.red
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: current <
                                      state.properties.pagination!.lastPage
                                  ? Colors.red
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Text(
                            "Next Page",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: current <
                                      state.properties.pagination!.lastPage
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is SearchPropertyError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
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

Widget _buildAmenitiesSection(Property property) {
  // Map of amenity keys to display names
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

  // Extracting available amenities
  final availableAmenities = amenitiesLabels.entries
      .where((entry) => property.toJson()[entry.key] == 1)
      .map((entry) => entry.value)
      .toList();

  print(availableAmenities);
  if (availableAmenities.isEmpty) {
    return SizedBox(); // Return an empty widget if no amenities are available
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Amenities:',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 6),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: availableAmenities.map((amenity) {
          return Chip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            label: Text(amenity),
            backgroundColor: Colors.grey.shade200,
          );
        }).toList(),
      ),
    ],
  );
}

Widget _buildDropdownWithIcons(String label, List<Map<String, dynamic>> items,
    String? selectedItem, ValueChanged<String?> onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        value: selectedItem,
        icon: Icon(Icons.arrow_drop_down_sharp, color: Colors.grey),
        hint: Text(label),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((Map<String, dynamic> item) {
          return DropdownMenuItem<String>(
            value: item['label'],
            child: Row(
              children: [
                Icon(item['icon'], color: Colors.red, size: 20),
                SizedBox(width: 10),
                Text(item['label']),
              ],
            ),
          );
        }).toList(),
      ),
    ),
  );
}
