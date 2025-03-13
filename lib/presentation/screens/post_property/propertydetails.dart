import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/post_property_details/post_property_details_bloc.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/upload_image.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/screens/post_property/post_property_depenency.dart/dependency_class.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/buildcard.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/checkboxes.dart';
// import 'package:my_zero_broker/presentation/screens/post_property/widgets/dropdown.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/image_pick.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/section_title.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/xtraAmenities.dart';
// import 'package:my_zero_broker/presentation/widgets/ElevatedButton.dart';
import 'package:my_zero_broker/presentation/widgets/TextField.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';

class PropertyDetailsFormScreen extends StatefulWidget {
  @override
  State<PropertyDetailsFormScreen> createState() =>
      _PropertyDetailsFormScreenState();
}

class _PropertyDetailsFormScreenState extends State<PropertyDetailsFormScreen> {
  List<Map<String, dynamic>> selectedAmenities = [];
  final _formKey = GlobalKey<FormState>();
  final cityDetails = locator.get<AreaDetailsDependency>().cityDetails.map((e) {
    return {
      "label": e.cName,
      "icon": Icons.location_city,
      "id": e.id.toString()
    };
  }).toList();

  void _updateAmenities(List<Map<String, dynamic>> amenities) {
    setState(() {
      selectedAmenities = amenities;
    });
  }

  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController plotAreaController = TextEditingController();
  final TextEditingController streetAreaController = TextEditingController();
  final TextEditingController offerPriceController = TextEditingController();
  final TextEditingController maintenanceCostController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late List<Map<String, dynamic>> areas;
  String? selectedPropertyType;
  String? selectedBhkType;
  String? selectedPropertyAge;
  String? selectedTotalFloor;
  String? selectedOwnershipType;
  String? selectedFacing;
  String? selectedCity;
  String? selectedLocality;
  String? selectedFurnishing;
  String? selectedParking;
  int? locality_id;
  int? city_id;
  String? selectedKitchenType;
  String? selectedBathroom;
  String? selectedWaterSupply;
  String? selectedGratedSecurity;
  String? selectedBalcony;
  String? selectedInternetService;
  String? selectedKhataCert;
  String? selectedSaleDeedCertificate;
  String? selectedPropertyTax;
  String? selectedOccupancyCertificate;
  List<String> photosUrls = [];
  List<File> images = [];

  bool _isPriceNegotiableSelected = false;
  bool _isCurrentlyUnderLoanSelected = false;
  bool success = false;

  Future<void> _pickDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    areas = locator
        .get<AreaDetailsDependency>()
        .areas[locator.get<PostPropertyDependency>().city.toUpperCase()]!
        .toList() as List<Map<String, dynamic>>;
    print(areas);
  }

  String _setFloor(String s) {
    if (s == "Ground Only") {
      return "0";
    } else if (s == "Ground+1") {
      return "1";
    } else if (s == "Ground+2") {
      return "2";
    } else if (s == "Ground+3") {
      return "3";
    } else {
      return "0";
    }
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (images.isNotEmpty) {
        for (File image in images) {
          final url = await UploadImage.uploadImage(image);
          photosUrls.add(url);
        }
        print(photosUrls);
      }

      // Map amenities to payload format (true -> 1, false -> 0)
      final Map<String, int> amenitiesMap = {};
      for (var amenity in selectedAmenities) {
        String key = amenity['label'].toLowerCase().replaceAll(' ', '_');
        amenitiesMap[key] = amenity['value'] ? 1 : 0;
      }

      final Map<String, dynamic> propertyDetails = {
        "user_id": locator.get<UserDetailsDependency>().id,
        "bhk": selectedBhkType.toString(),
        "property": locator.get<PostPropertyDependency>().isResidential
            ? "Residential"
            : "Commercial",
        "purpose": locator.get<PostPropertyDependency>().adType,
        "property_type": selectedPropertyType.toString(),
        "property_age": selectedPropertyAge.toString(),
        "carpet_area_sqft": carpetAreaController.text.toString(),
        "floor": _setFloor(selectedTotalFloor!),
        "balcony": selectedBalcony.toString(),
        "available_for_lease": "1",
        "expected_rent": "1",
        "total_floor": selectedTotalFloor.toString(),
        "deposit": "0",
        "negotiable": "0",
        "ownership": selectedOwnershipType.toString(),
        "facing": selectedFacing.toString(),
        "area_sqft": plotAreaController.text.toString(),
        "maintenance": maintenanceCostController.text.toString(),
        "furnishing": selectedFurnishing.toString(),
        "preferred_tenants": "1",
        "parking_type": selectedParking.toString(),
        "water_supply": selectedWaterSupply.toString(),
        "description": descriptionController.text.toString(),
        "area": plotAreaController.text.toString(),
        "expected_price": offerPriceController.text.toString(),
        "maintenance_cost": maintenanceCostController.text,
        "price_negotiable": _isPriceNegotiableSelected ? 1 : 0,
        "underloan": _isCurrentlyUnderLoanSelected ? "1" : "0",
        "lease_years": "2",
        "available_from": DateTime.now().toString(),
        "khata_cert": selectedKhataCert.toString(),
        "deed_cert": selectedSaleDeedCertificate.toString(),
        "property_tax": selectedPropertyTax.toString(),
        "occupancy_cert": selectedOccupancyCertificate.toString(),
        "city_id": city_id.toString() ?? "0",
        "locality_id": locality_id.toString() ?? "0",
        "street": streetAreaController.text.toString(),
        "photos": photosUrls,

        // Add amenities from the payload
        "lift": amenitiesMap['lift'] ?? 0,
        "internet_service": amenitiesMap['internet_service'] ?? 0,
        "air_conditioner": amenitiesMap['air_conditioner'] ?? 0,
        "club_house": amenitiesMap['club_house'] ?? 0,
        "intercom": amenitiesMap['intercom'] ?? 0,
        "swimming_pool": amenitiesMap['swimming_pool'] ?? 0,
        "childrens_play_area": amenitiesMap['childrens_play_area'] ?? 0,
        "fire_safety": amenitiesMap['fire_safety'] ?? 0,
        "servant_room": amenitiesMap['servant_room'] ?? 0,
        "shopping_center": amenitiesMap['shopping_center'] ?? 0,
        "gas_pipeline": amenitiesMap['gas_pipeline'] ?? 0,
        "park": amenitiesMap['park'] ?? 0,
        "rain_water_harvesting": amenitiesMap['rain_water_harvesting'] ?? 0,
        "sewage_treatment": amenitiesMap['sewage_treatment_plant'] ?? 0,
        "house_keeping": amenitiesMap['house_keeping'] ?? 0,
        "power_backup": amenitiesMap['power_backup'] ?? 0,
        "visitor_parking": amenitiesMap['visitor_parking'] ?? 0,
      };

      BlocProvider.of<PostPropertyDetailsBloc>(context)
          .add(PostPropertyEventToApi(propertyDetails: propertyDetails));
    } else {
      Snack.show("All Fields are Required!!", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Post Property Details"),
        centerTitle: true,
        leading: Image.asset(
          'assets/images/my_zero_broker_logo (2).png',
          height: height * 0.08,
          width: width * 0.5,
        ),
        backgroundColor: Colors.red,
      ),
      body: BlocListener<PostPropertyDetailsBloc, PostPropertyDetailsState>(
        listener: (context, state) {
          if (state is PostPropertyDetailsSuccessState) {
            Snack.show(state.successMessage, context);
            Navigator.pushNamed(context, RoutesName.homeScreen);
          } else if (state is PostPropertyDetailsFailureState) {
            Snack.show(state.failureMessage, context);
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
                      children: [
                        const SectionTitle(title: "Property Details"),
                        _buildDropdownField(
                            "Property Type",
                            selectedPropertyType,
                            locator.get<PostPropertyDependency>().isResidential
                                ? [
                                    "Row House",
                                    "Individual Villa/Bunglow",
                                    "Farm House",
                                    "Flat",
                                    "Twin Bunglow"
                                  ]
                                : [
                                    "Office",
                                    "Store Room",
                                    "Shop",
                                    "Show Room",
                                    "Industrial Building",
                                    "Gowdown Warehouse"
                                  ], (val) {
                          setState(() {
                            selectedPropertyType = val;
                          });
                        }),
                        Visibility(
                          visible: locator
                              .get<PostPropertyDependency>()
                              .isResidential,
                          child: _buildDropdownField(
                              "BHK Type", selectedBhkType, [
                            "1 RK",
                            "1 BHK",
                            "2 BHK",
                            "3 BHK",
                            "4 or more BHK"
                          ], (val) {
                            setState(() {
                              selectedBhkType = val;
                            });
                          }),
                        ),
                        _buildDropdownField(
                            "Property Age", selectedPropertyAge, [
                          "Under Construction/ New Construction",
                          "Ready Possession"
                        ], (val) {
                          setState(() {
                            selectedPropertyAge = val;
                          });
                        }),
                        _buildTextField("Carpet/BuiltUp Area (Sq. Ft.)",
                            carpetAreaController),
                        _buildDropdownField("Total Floor", selectedTotalFloor, [
                          "Ground Only",
                          "Ground+1",
                          "Ground+2",
                          "Ground+3"
                        ], (val) {
                          setState(() {
                            selectedTotalFloor = val;
                          });
                        }),
                        _buildDropdownField(
                            "Ownership Type",
                            selectedOwnershipType,
                            ["On lease", "Self Owned"], (val) {
                          setState(() {
                            selectedOwnershipType = val;
                          });
                        }),
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
                        _buildTextField(
                            "Plot Area (Sq. Ft.)", plotAreaController),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  buildCard(
                    child: Column(
                      children: [
                        const SectionTitle(title: "Locality Details"),
                        _buildDropdownField(
                            "City",
                            selectedCity,
                            locator
                                .get<AreaDetailsDependency>()
                                .areas
                                .keys
                                .toList(), (val) {
                          setState(() {
                            final l = cityDetails
                                .where((element) => element["label"] == val)
                                .where((element) => element["label"] == val)
                                .toList();

                            if (val! != selectedCity) {
                              areas = locator
                                  .get<AreaDetailsDependency>()
                                  .areas[val!]!
                                  .toList() as List<Map<String, dynamic>>;
                              selectedLocality = null;
                            }

                            city_id = int.parse(l.first["id"].toString());
                            selectedCity = val;
                            print(city_id);
                          });
                        }),
                        _buildDropdownField(
                            "Locality",
                            selectedLocality,
                            selectedCity == null
                                ? []
                                : areas
                                    .map((e) => e["a_name"].toString())
                                    .toList(), (v) {
                          setState(() {
                            final l = areas;
                            locality_id = areas
                                .where((element) => element["a_name"] == v)
                                .first["id"];
                            selectedLocality = v;
                          });
                        }),
                        _buildTextField("Street/Area", streetAreaController),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  buildCard(
                    child: Column(
                      children: [
                        const SectionTitle(title: "Sale/Resale Details"),
                        _buildTextField("Expected Price", offerPriceController),
                        _buildTextField("Maintenance Cost (/month)",
                            maintenanceCostController),
                        _buildCheckbox(
                            "Price Negotiable", _isPriceNegotiableSelected,
                            (value) {
                          setState(() {
                            _isPriceNegotiableSelected = value ?? false;
                          });
                        }),
                        _buildCheckbox("Currently Under Loan",
                            _isCurrentlyUnderLoanSelected, (value) {
                          setState(() {
                            _isCurrentlyUnderLoanSelected = value ?? false;
                          });
                        }),
                        // _buildDateField(),
                        _buildDropdownField("Furnishing", selectedFurnishing, [
                          "Fully-Furnished",
                          "Semi-Furnished",
                          "Unfurnished"
                        ], (value) {
                          setState(() {
                            selectedFurnishing = value;
                          });
                        }),
                        _buildDropdownField("Parking", selectedParking,
                            ["Bike", "Car", "Bike & Car", "None"], (val) {
                          setState(() {
                            selectedParking = val;
                          });
                        }),
                       Visibility(visible: locator.get<PostPropertyDependency>().isResidential,child:  _buildDropdownField("Kitchen Type", selectedKitchenType,
                            ["Modular", "Covered Shelves", "Open Shelves"],
                            (val) {
                          setState(() {
                            selectedKitchenType = val;
                          });
                        }),), 
                        _buildTextField("Description", descriptionController),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  buildCard(
                    child: Column(
                      children: [
                        const SectionTitle(title: "Gallery"),
                        GalleryImagePicker(onImagesPicked: (pickedImages) {
                          images = pickedImages;
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  buildCard(
                    child: Column(
                      children: [
                        const SectionTitle(title: "Amenities"),
                        _buildDropdownField("Bathroom(s)", selectedBathroom,
                            ["1", "2", "3", "4", "5"], (val) {
                          setState(() {
                            selectedBathroom = val;
                          });
                        }),
                        _buildDropdownField("Water Supply", selectedWaterSupply,
                            ["Corporation", "Borewell", "Both"], (val) {
                          setState(() {
                            selectedWaterSupply = val;
                          });
                        }),
                        _buildDropdownField("Grated Security",
                            selectedGratedSecurity, ["Yes", "No"], (val) {
                          setState(() {
                            selectedGratedSecurity = val;
                          });
                        }),
                        _buildDropdownField("Balcony", selectedBalcony,
                            ["1", "2", "3", "4", "5"], (val) {
                          setState(() {
                            selectedBalcony = val;
                          });
                        }),
                        _buildDropdownField("Internet Service",
                            selectedInternetService, ["Yes", "No"], (val) {
                          setState(() {
                            selectedInternetService = val;
                          });
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  buildCard(
                    child: Column(
                      children: [
                        const SectionTitle(title: "Additional Information"),
                        _buildDropdownField(
                            "Khata Certificate (7/12)",
                            selectedKhataCert,
                            ["Yes", "No", "Don't Know"], (val) {
                          setState(() {
                            selectedKhataCert = val;
                          });
                        }),
                        _buildDropdownField(
                            "Sale Deed Certificate",
                            selectedSaleDeedCertificate,
                            ["Yes", "No", "Don't Know"], (val) {
                          setState(() {
                            selectedSaleDeedCertificate = val;
                          });
                        }),
                        _buildDropdownField(
                            "Property Tax Paid",
                            selectedPropertyTax,
                            ["Yes", "No", "Don't Know"], (val) {
                          setState(() {
                            selectedPropertyTax = val;
                          });
                        }),
                        _buildDropdownField(
                            "Occupancy Certificate",
                            selectedOccupancyCertificate,
                            ["Yes", "No", "Don't Know"], (val) {
                          setState(() {
                            selectedOccupancyCertificate = val;
                          });
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  buildCard(
                    child: Column(
                      children: [
                        const SectionTitle(title: "Extra Amenities"),
                        ExtraAmenitieWidget(
                            onAmenitiesChanged: _updateAmenities),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Center(
                    child: BlocBuilder<PostPropertyDetailsBloc,
                        PostPropertyDetailsState>(
                      builder: (context, state) {
                        if (state is PostPropertyDetailsLoading) {
                          return ElevatedButton(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                              foregroundColor: Colors.grey.shade500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              minimumSize: Size(400, 60),
                            ),
                            onPressed: () {},
                          );
                        }

                        return ElevatedButton(
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
                            final propertyDetailsForm = _submitForm();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: (newValue) {
          onChanged(newValue); // Update the variable via reference
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
      child: Textfield(
        controller: controller,
        textInputType: TextInputType.text,
        hintText: hintText,
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Please enter $hintText';
          }
          return null;
        },
      ),
    );
  }
}

Widget _buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: CustomCheckbox(
      label: label,
      initialValue: value,
      onChanged: onChanged,
    ),
  );
}
