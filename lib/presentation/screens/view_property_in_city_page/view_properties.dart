import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/search_property/search_property_bloc.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/models/property_in_cities_model.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/image_carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProperties extends StatefulWidget {
  const ViewProperties(
      {super.key,
      required this.city_id,
      required this.status,
      required this.bhk,
      required this.area});
  final String city_id;
  final String status;
  final area;
  final String bhk;

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

  bool show = false;
  List<dynamic> areas = [];
  late String selectedArea;
  List<Property> props = [];
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchPropertyBloc>(context).add(SearchBuyProperty(
        city_id: widget.city_id,
        area_id: widget.area ?? "0",
        page: current,
        bhk: widget.bhk,
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
                      //filter options here
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

                                    // Filter properties by the selected area
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
                                            area_id: areaId,
                                            bhk: widget.bhk,
                                            page: current,
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

                                  // Reset to unfiltered properties
                                  BlocProvider.of<SearchPropertyBloc>(context)
                                      .add(SearchBuyProperty(
                                          city_id: widget.city_id,
                                          area_id: "0",
                                          bhk: widget.bhk,
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

                                // print(photos);
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
                                        // Header: Logo & Title
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
                                        // Property Details
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
                                                (widget.status == "Commercial"
                                                        ? "CS"
                                                        : widget.status ==
                                                                "Rent"
                                                            ? "RR"
                                                            : widget.status ==
                                                                    ""
                                                                ? "RS"
                                                                : "PR") +
                                                    property.id.toString(),
                                                Colors.blue),
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
                                            _detailRow(
                                                'Location:',
                                                state.properties.cityName
                                                    .toString(),
                                                Colors.red),
                                            _detailRow('Area :',
                                                area.toString(), Colors.red),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        _detailRow(
                                            "BHK", property.bhk.toString()),
                                        _detailRow(
                                            'Plot Area:',
                                            property.areaSqft.toString() ==
                                                    "null"
                                                ? "Not Defined"
                                                : (property.areaSqft
                                                        .toString() +
                                                    ' sqFT')),
                                        _detailRow(
                                            'Built-Up Area:',
                                            property.carpetAreaSqft
                                                        .toString() ==
                                                    "null"
                                                ? "Not Defined"
                                                : (property.carpetAreaSqft
                                                        .toString() +
                                                    ' sqFT')),
                                        _detailRow('Property Age:',
                                            property.propertyAge.toString()),
                                        _detailRow('Floors:',
                                            property.totalFloor.toString()),
                                        _detailRow('Facing:',
                                            property.facing.toString()),
                                        _detailRow(
                                            'Offer:',
                                            "₹" +
                                                property.expectedPrice
                                                    .toString(),
                                            Colors.green),
                                        _detailRow(
                                            'Maintainance:',
                                            '₹' +
                                                property.maintenanceCost
                                                    .toString()),
                                        _detailRow('Furnishing:',
                                            property.furnishing.toString()),
                                        _detailRow('Parking:',
                                            property.parkingType.toString()),
                                        _detailRow('Kitchen Type:',
                                            property.kitchenType.toString()),
                                        _detailRow('Bathrooms:',
                                            property.bathroom.toString()),
                                        _detailRow('Balcony:',
                                            property.balcony.toString()),
                                        SizedBox(height: 6),
                                        Text(
                                          property.description ?? "",
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            minimumSize:
                                                Size(double.infinity, 40),
                                          ),
                                          child: Text('Get Owner Details'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
