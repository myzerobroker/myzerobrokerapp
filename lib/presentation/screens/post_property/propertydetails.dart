import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/post_property_details/post_property_details_bloc.dart';
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
  final _formKey = GlobalKey<FormState>();
  final cityDetails = locator.get<AreaDetailsDependency>().cityDetails.map((e) {
    return {
      "label": e.cName,
      "icon": Icons.location_city,
      "id": e.id.toString()
    };
  }).toList();

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
      }
      print(photosUrls);
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
        "club_house": 1,
        "intercom": 1,
        "grated_security": selectedGratedSecurity.toString(),
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
        "photos": photosUrls
      };

      // print(propertyDetails);
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
                            "Property Type", selectedPropertyType, [
                          "Row House",
                          "Individual Villa/Bunglow",
                          "Farm House",
                          "Flat",
                          "Twin Bunglow"
                        ], (val) {
                          setState(() {
                            selectedPropertyType = val;
                          });
                        }),
                        _buildDropdownField("BHK Type", selectedBhkType, [
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
                        _buildDropdownField("Kitchen Type", selectedKitchenType,
                            ["Modular", "Covered Shelves", "Open Shelves"],
                            (val) {
                          setState(() {
                            selectedKitchenType = val;
                          });
                        }),
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
                        ExtraAmenitieWidget()
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
  //  Widget _buildDateField() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: TextFormField(
  //       controller: _dateController,
  //       decoration: InputDecoration(
  //         labelText: 'Available From',
  //         hintText: 'Select a date',
  //         suffixIcon: Icon(Icons.calendar_today),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12.0),
  //         ),
  //       ),
  //       readOnly: true,
  //       onTap: () => _pickDate(context),
  //     ),
  //   );
  // }




// {
// //   "_token": "St39Ee4JidJqTatyfsEKA9m90V4fPcSSrcLB0O6P",
//   "user_id": 160,
//   "bhk": "2",
//   "property": "Commercial",
//   "purpose": "Sale",
//   "property_type": "Office",
//   "property_age": "Ready Possession",
//   "carpet_area_sqft": "1000",
//   "floor": "4",
//   "balcony":"3",
//   "available_for_lease":"1",
//   "expected_rent":"1",
//   "total_floor": "4",
//   "deposit":"0",
//   "negotiable":"0",
//   "ownership": "On lease",
//   "facing": "North",
//   "area_sqft": "10000",
//   "maintenance":"10000",
//   "furnishing": "Fully-Furnished",
//   "preferred_tenants":"asdsad",
//   "parking_type": "Bike",
//   "water_supply":"Corporation",
//   "description": "good property",
//   "club_house": 1,
//   "intercom": 1,
//   "grated_security":"1",
//   "area":"1112",
//   "expected_price": 5,
//   "maintenance_cost": 10,
//   "price_negotiable": 1,
//   "underloan": "1",
//   "lease_years": 2,
//   "available_from": "2024-12-03",
//   "khata_cert": "Yes",
//   "deed_cert": "Yes",
//   "property_tax": "Yes",
//   "occupancy_cert": "Yes",
//   "city_id": 6,
//   "locality_id": 31,
//   "street": "ABC palace",
//   "photos": []
// }
