import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/post_farmland/post_farmland_bloc.dart';
import 'package:my_zero_broker/bloc/post_farmland/post_farmland_event.dart';
import 'package:my_zero_broker/bloc/post_farmland/post_farmland_state.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/upload_image.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/buildcard.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/image_pick.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/section_title.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

class PostFarmland extends StatefulWidget {
  @override
  State<PostFarmland> createState() => _PostFarmlandState();
  final List<Map<String, dynamic>> areas;

  const PostFarmland({super.key, required this.areas});
}

class _PostFarmlandState extends State<PostFarmland> {
  final locations = locator.get<AreaDetailsDependency>().cityDetails.map((e) {
    return {
      "label": e.cName,
      "icon": Icons.location_city,
      "id": e.id.toString()
    };
  }).toList();

  List<String> photosUrl = [];
  List<File> image = [];

  String? _selectedLocation;
  String? _selectedArea;
  int? locality_id;
  int? cityId;
  late List<Map<String, dynamic>> areas;
  @override
  void initState() {
    super.initState();

    areas = widget.areas;

    print(areas);
    print("Initialized areas: $areas");
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController plotAreaController = TextEditingController();
  final TextEditingController plotFrontController = TextEditingController();
  final TextEditingController plotDepthController = TextEditingController();
  final TextEditingController frontRoadController = TextEditingController();
  final TextEditingController sideRoadController = TextEditingController();
  final TextEditingController offerPriceController = TextEditingController();
  final TextEditingController streetAreaController = TextEditingController();

  String? selectedFacing;
  String? selectedPlotType;

  Widget _buildDropdownFieldWithIcons(String label, String? value,
      List<Map<String, dynamic>> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsPalette.secondaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
          icon: Icon(Icons.arrow_drop_down_sharp, color: Colors.grey),
          hint: Text(label,
              style: TextStyle(
                color: ColorsPalette.primaryColor,
                fontSize: 16,
              )),
          onChanged: onChanged,
          items:
              items.map<DropdownMenuItem<String>>((Map<String, dynamic> item) {
            return DropdownMenuItem<String>(
              value: item['label'],
              child: Row(
                children: [
                  Icon(item['icon'],
                      color: ColorsPalette.primaryColor, size: 20),
                  SizedBox(width: 10),
                  Text(item['label'],
                      style: TextStyle(
                        color: ColorsPalette.primaryColor,
                        fontSize: 16,
                      )),
                ],
              ),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: ColorsPalette.primaryColor,
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: ColorsPalette.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ))
            .toList(),
        onChanged: (newValue) {
          onChanged(newValue);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller,
      [bool isRequired = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: ColorsPalette.primaryColor.withOpacity(0.9),
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Please fill out this field';
          }
          return null;
        },
      ),
    );
  }

  _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (image.isNotEmpty) {
        for (File images in image) {
          final url = await UploadImage.uploadImage(images);
          photosUrl.add(url);
        }
        print(photosUrl);
      }
      final Map<String, int> amenitiesMap = {
        "lift": 0, // Example: Set to 1 if applicable in your UI
        "internet_service": 0,
        "air_conditioner": 0,
        "club_house": 0,
        "intercom": 1, // Already set as 1 in your original code
        "swimming_pool": 0,
        "childrens_play_area": 0,
        "fire_safety": 0,
        "servant_room": 0,
        "shopping_center": 0,
        "gas_pipeline": 0,
        "park": 0,
        "rain_water_harvesting": 0,
        "sewage_treatment_plant": 0,
        "house_keeping": 0,
        "power_backup": 0,
        "visitor_parking": 0,
      };

      final Map<String, dynamic> propertyDetails = {
        "user_id": locator.get<UserDetailsDependency>().id,
        "property_type": selectedPlotType ?? "null", // Ensure null safety
        "property_age": "0", // Default for farmland/plot
        "bhk": "null", // Not applicable for farmland
        "floor": "0", // Not applicable for farmland
        "total_floor": "0", // Not applicable for farmland
        "ownership": "null", // Could be updated if you add ownership selection
        "facing": selectedFacing?.toString() ?? "null", // Ensure null safety
        "property": "Plot",
        "purpose": "Sale", // Ensure null safety
        "area_sqft":
            plotAreaController.text.isNotEmpty ? plotAreaController.text : "0",
        "carpet_area_sqft": "0", // Not applicable for farmland
        "plot_front": plotFrontController.text.isNotEmpty
            ? plotFrontController.text
            : "0",
        "plot_depth": plotDepthController.text.isNotEmpty
            ? plotDepthController.text
            : "0",
        "front_road": frontRoadController.text.isNotEmpty
            ? frontRoadController.text
            : "0",
        "side_road":
            sideRoadController.text.isNotEmpty ? sideRoadController.text : "0",
        "expected_price": offerPriceController.text.isNotEmpty
            ? offerPriceController.text
            : "0",
        "street": streetAreaController.text.isNotEmpty
            ? streetAreaController.text
            : "null",
        "photos": photosUrl.toString(),
        "location": _selectedLocation ?? "null", // Ensure null safety
        "area": _selectedArea ?? "null", // Ensure null safety
        "city_id": cityId?.toString() ?? "0",
        "locality_id": locality_id?.toString() ?? "0",
        "available_for_lease": "1", // Default as per your original code
        "expected_rent": "1", // Default as per your original code
        "deposit": "0", // Default as per your original code
        "negotiable": "0", // Default as per your original code
        "preferred_tenants": "1", // Default as per your original code

        // Additional fields from the reference
        "balcony": "0", // Not applicable for farmland, default to 0
        "maintenance": "0", // Add field if you include maintenance cost in UI
        "furnishing": "null", // Not applicable for farmland
        "parking_type": "null", // Add field if you include parking type in UI
        "water_supply": "null", // Add field if you include water supply in UI
        "description": "", // Add a description field in UI if needed
        "maintenance_cost":
            "0", // Add field if you include maintenance cost in UI
        "price_negotiable": 0, // Could be a boolean toggle in UI
        "underloan": "0", // Could be a boolean toggle in UI
        "khata_cert":
            "null", // Add field if you include khata certificate in UI
        "deed_cert":
            "null", // Add field if you include sale deed certificate in UI
        "property_tax": "null", // Add field if you include property tax in UI
        "occupancy_cert":
            "null", // Add field if you include occupancy certificate in UI
        "lease_years": "2", // Default as per your original code
        "available_from": DateTime.now().toString(),

        // Amenities from the reference
        "lift": amenitiesMap['lift'],
        "internet_service": amenitiesMap['internet_service'],
        "air_conditioner": amenitiesMap['air_conditioner'],
        "club_house": amenitiesMap['club_house'],
        "intercom": amenitiesMap['intercom'],
        "swimming_pool": amenitiesMap['swimming_pool'],
        "childrens_play_area": amenitiesMap['childrens_play_area'],
        "fire_safety": amenitiesMap['fire_safety'],
        "servant_room": amenitiesMap['servant_room'],
        "shopping_center": amenitiesMap['shopping_center'],
        "gas_pipeline": amenitiesMap['gas_pipeline'],
        "park": amenitiesMap['park'],
        "rain_water_harvesting": amenitiesMap['rain_water_harvesting'],
        "sewage_treatment": amenitiesMap['sewage_treatment_plant'],
        "house_keeping": amenitiesMap['house_keeping'],
        "power_backup": amenitiesMap['power_backup'],
        "visitor_parking": amenitiesMap['visitor_parking'],
        "purpose": "Sale"
      };

      BlocProvider.of<PostFormladBloc>(context).add(
        PostPropertyEventToApi(propertyDetails: propertyDetails),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: ColorsPalette.bgColor,
        appBar: AppBar(
          title: const Text("Post your Plot/Farmland"),
          centerTitle: true,
          backgroundColor: ColorsPalette.primaryColor,
          foregroundColor: ColorsPalette.secondaryColor,
        ),
        body: BlocListener<PostFormladBloc, PostFormladState>(
          listener: (context, state) {
            if (state is PostFormladSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.successMessage)),
              );
            } else if (state is PostFormladFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.failureMessage)),
              );
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle(title: "Property Details"),
                          _buildTextField(
                              "Plot Area (Sq. Ft.)", plotAreaController, true),
                          _buildTextField(
                              "Plot Front (M)", plotFrontController, true),
                          _buildTextField(
                              "Plot Depth (M)", plotDepthController, true),
                          _buildTextField(
                              "Front Road (M)", frontRoadController, true),
                          _buildTextField(
                              "Side Road (M)", sideRoadController, false),
                          _buildTextField("Offer (in Lakhs Per Guntha)",
                              offerPriceController, true),
                          _buildDropdownField("Facing", selectedFacing, [
                            "East",
                            "West",
                            "North",
                            "South",
                            "East-South",
                            "East-North",
                            "West-South",
                            "West-North"
                          ], (val) {
                            setState(() {
                              selectedFacing = val;
                            });
                          }),
                          _buildDropdownField("Plot Type", selectedPlotType, [
                            "Residential Plot",
                            "Commercial Plot",
                            "Amenity",
                            "Farm Land",
                            "Industrial Plot"
                          ], (val) {
                            setState(() {
                              selectedPlotType = val;
                            });
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(title: "Locality Details"),
                          _buildDropdownFieldWithIcons(
                              "City",
                              _selectedLocation,
                              locator
                                  .get<AreaDetailsDependency>()
                                  .areas
                                  .keys
                                  .toList()
                                  .map((city) => {
                                        'label': city,
                                        'icon': Icons
                                            .location_city, // Example icon, you can adjust as needed
                                      })
                                  .toList(), (val) {
                            setState(() {
                              final l = locations
                                  .where((element) => element["label"] == val)
                                  .toList();

                              if (val != _selectedLocation) {
                                areas = widget.areas;
                                _selectedArea = null;
                              }

                              cityId = int.parse(l.first["id"].toString());
                              _selectedLocation = val;
                              print(cityId);
                            });
                          }),
                          _buildDropdownFieldWithIcons(
                              "Locality",
                              _selectedArea,
                              _selectedLocation == null
                                  ? []
                                  : areas
                                      .map((e) => {
                                            'label': e["a_name"].toString(),
                                            'icon': Icons
                                                .place, // Example icon for locality, can be adjusted
                                          })
                                      .toList(), (v) {
                            setState(() {
                              final l = areas;
                              locality_id = areas
                                  .where((element) => element["a_name"] == v)
                                  .first["id"];
                              _selectedArea = v;
                            });
                          }),
                          _buildTextField(
                              "Street/Area", streetAreaController, true),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.06),
                    buildCard(
                      child: Column(
                        children: [
                          const SectionTitle(title: "Gallery"),
                          Center(
                              child: Text(
                            "(Get 150% more responses by adding photos of your property)",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 99, 97, 97),
                                fontWeight: FontWeight.w500),
                          )),
                          GalleryImagePicker(onImagesPicked: (pickedImages) {
                            image = pickedImages;
                            print('Images picked: ${pickedImages.length}');
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.06),
                    SizedBox(height: 20),
                    Center(
                        child: ElevatedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        minimumSize: Size(400, 60),
                      ),
                      onPressed: () {
                        final postFarmland = _submitForm(context);
                        print(postFarmland);
                      },
                    )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
