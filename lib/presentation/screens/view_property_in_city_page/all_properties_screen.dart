// all_properties_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_zero_broker/bloc/search_property/search_property_bloc.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/models/property_in_cities_model.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/screens/view_property_in_city_page/property_detail_screen.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/presentation/widgets/image_carousel.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllPropertiesScreen extends StatefulWidget {
  const AllPropertiesScreen({
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
  final dynamic area;
  final String bhk;
  final String propertyType;
  final String priceRange;

  @override
  State<AllPropertiesScreen> createState() => _AllPropertiesState();
}

class _AllPropertiesState extends State<AllPropertiesScreen> {
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
    selectedArea = widget.area == ""
        ? "Select Area"
        : locator
            .get<AreaDetailsDependency>()
            .areas[cityDetails.firstWhere(
                (element) => element["id"] == widget.city_id)["label"]]!
            .firstWhere((element) =>
                element["id"].toString() == widget.area.toString())["a_name"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Properties in ${cityDetails.firstWhere((element) => element["id"] == widget.city_id)["label"]}",
            style: TextStyles.subHeadingStyle),
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
        child: BlocBuilder<SearchPropertyBloc, SearchPropertyState>(
          builder: (context, state) {
            if (state is SearchPropertyLoaded) {
              props = state.properties.properties!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Total Pages", style: TextStyles.bodyStyle),
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
                                  decoration: BoxDecoration(
                                    color: current == index + 1
                                        ? ColorsPalette.primaryColor
                                        : ColorsPalette.cardBgColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: current == index + 1
                                            ? ColorsPalette.primaryColor
                                            : Colors.grey.shade200),
                                  ),
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      color: current == index + 1
                                          ? ColorsPalette.cardBgColor
                                          : ColorsPalette.textPrimaryColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Filter Options", style: TextStyles.bodyStyle),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                    Icon(Icons.map,
                                        color: ColorsPalette.iconColor),
                                    const SizedBox(width: 10),
                                    Text("Filter Area",
                                        style: TextStyles.bodyStyle),
                                  ],
                                ),
                                items: areas.map((e) {
                                  return DropdownMenuItem<String>(
                                    value: e,
                                    child: Row(
                                      children: [
                                        Icon(Icons.map,
                                            color: ColorsPalette.primaryColor),
                                        const SizedBox(width: 8),
                                        Text(e, style: TextStyles.bodyStyle),
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
                                });
                              },
                              child: Text("Remove Filter",
                                  style: TextStyles.buttonStyle),
                            ),
                          ),
                        ],
                      ),
                      state.properties.properties!.isEmpty
                          ? Center(
                              child: Text("No Results Found",
                                  style: TextStyles.bodyStyle))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: props.length,
                              itemBuilder: (context, index) {
                                final property = props[index];
                                final List photos =
                                    jsonDecode(property.photos!);
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
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PropertyDetailScreen(
                                          property: property,
                                          peropertyStatus: widget.status,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Card(
                                      color: ColorsPalette.cardBgColor,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      elevation: 0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return _buildShimmer();
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
                                                  style: TextStyles.bodyStyle
                                                      .copyWith(
                                                          color: ColorsPalette
                                                              .textSecondaryColor),
                                                ),
                                                Text(
                                                  widget.status == 'Rent'
                                                      ? 'Rent: ${formatPrice(property.expectedRent.toString())}'
                                                      : 'Price: ${formatPrice(property.expectedPrice.toString())}',
                                                  style: TextStyles.priceStyle,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.star,
                                                            color: ColorsPalette
                                                                .starColor,
                                                            size: 16),
                                                        Text("4.5",
                                                            style: TextStyles
                                                                .bodyStyle),
                                                        Text(
                                                            " For ${widget.status}",
                                                            style: TextStyles
                                                                .bodyStyle),
                                                      ],
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        SharedPreferences prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        String? token = prefs
                                                            .getString(
                                                                "authToken");

                                                        if (token == null) {
                                                          Snack.show(
                                                              "Please log in to get owner details",
                                                              context);
                                                          return;
                                                        }

                                                        Map<String, dynamic>
                                                            payload = {
                                                          "property_id":
                                                              property.id,
                                                        };

                                                        try {
                                                          final response =
                                                              await http.post(
                                                            Uri.parse(
                                                                'https://myzerobroker.com/api/get-owner-details'),
                                                            headers: {
                                                              'Content-Type':
                                                                  'application/json',
                                                              'Accept':
                                                                  'application/json',
                                                              'Authorization':
                                                                  'Bearer $token',
                                                            },
                                                            body: jsonEncode(
                                                                payload),
                                                          );

                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            var responseData =
                                                                jsonDecode(
                                                                    response
                                                                        .body);
                                                            Snack.show(
                                                                responseData[
                                                                        'message'] ??
                                                                    "Details fetched successfully",
                                                                context);
                                                          } else {
                                                            var responseData =
                                                                jsonDecode(
                                                                    response
                                                                        .body);
                                                            Snack.show(
                                                                responseData[
                                                                        'message'] ??
                                                                    "Failed to fetch owner details",
                                                                context);
                                                          }
                                                        } catch (e) {
                                                          Snack.show(
                                                              "Error: $e",
                                                              context);
                                                        }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.black,
                                                        foregroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        minimumSize:
                                                            Size(0, 40),
                                                      ),
                                                      child: Text(
                                                          'Get Owner Details'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
                          height: 40,
                          width: double.infinity,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                current < state.properties.pagination!.lastPage
                                    ? ColorsPalette.primaryColor
                                    : ColorsPalette.cardBgColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: current <
                                      state.properties.pagination!.lastPage
                                  ? ColorsPalette.primaryColor
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Next Page",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: current <
                                        state.properties.pagination!.lastPage
                                    ? ColorsPalette.cardBgColor
                                    : ColorsPalette.textPrimaryColor,
                              ),
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
                  child: Text(state.message, style: TextStyles.bodyStyle));
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: List.generate(5, (index) => _buildShimmerCard()),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsPalette.cardBgColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _buildShimmerEffect(),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Card(
        color: ColorsPalette.cardBgColor,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 20,
                    decoration: BoxDecoration(
                      color: ColorsPalette.secondaryColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _buildShimmerEffect(),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 200,
                    height: 24,
                    decoration: BoxDecoration(
                      color: ColorsPalette.secondaryColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _buildShimmerEffect(),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: ColorsPalette.secondaryColor.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: _buildShimmerEffect(),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 50,
                            height: 20,
                            decoration: BoxDecoration(
                              color: ColorsPalette.secondaryColor.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: _buildShimmerEffect(),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 100,
                            height: 20,
                            decoration: BoxDecoration(
                              color: ColorsPalette.secondaryColor.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: _buildShimmerEffect(),
                          ),
                        ],
                      ),
                      Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ColorsPalette.secondaryColor.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _buildShimmerEffect(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: ColorsPalette.cardBgColor.withOpacity(0.8),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorsPalette.bgColor.withOpacity(0.3),
                  ColorsPalette.secondaryColor.withOpacity(0.5),
                  ColorsPalette.bgColor.withOpacity(0.3),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              onEnd: () {
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }
}