import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/post_farmland/post_farmland_bloc.dart';
import 'package:my_zero_broker/bloc/post_farmland/post_farmland_event.dart';
import 'package:my_zero_broker/bloc/post_farmland/post_farmland_state.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/user_id.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/buildcard.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/image_pick.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/section_title.dart';

class PostFarmland extends StatefulWidget {
  @override
  State<PostFarmland> createState() => _PostFarmlandState();
}

class _PostFarmlandState extends State<PostFarmland> {
  final locations = locator.get<AreaDetailsDependency>().cityDetails.map((e) {
    return {
      "label": e.cName,
      "icon": Icons.location_city,
      "id": e.id.toString()
    };
  }).toList();

  String? _selectedLocation;
  String? _selectedArea;
  int? city_id;
  int? areaId;
  

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
          items:
              items.map<DropdownMenuItem<String>>((Map<String, dynamic> item) {
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

   _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> propertyDetails = {
        "user_id": locator.get<UserId>().id,
        "property_type": "Plot",
        "property_age":"0",
        "bhk":"null",
        "floor":"0",
        "total_floor":"0",
        "ownership":"null",
        "facing":"null",
        "property": "Plot",
        "purpose": "Sale",
        "area_sqft": plotAreaController.text,
        "plot_front": plotFrontController.text,
        "plot_depth": plotDepthController.text,
        "front_road": frontRoadController.text,
        "side_road": sideRoadController.text,
        "expected_price": offerPriceController.text,
        "street": streetAreaController.text,
        "photos": [],
        "location": _selectedLocation,
        "area": _selectedArea,
        "city_id": city_id ?? 0,
        "locality_id": areaId ?? 0,
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Post your Plot/Farmland"),
          centerTitle: true,
          backgroundColor: Colors.red,
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
                          _buildTextField("Offer Price (in Lakhs Per Guntha)",
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
                          _buildDropdownWithIcons(
                              'Search Location', locations, _selectedLocation,
                              (String? newValue) {
                            setState(() => _selectedLocation = newValue);
                          }),
                          _buildDropdownWithIcons(
                              'Search Area',
                              _selectedLocation == null
                                  ? []
                                  : (locator
                                              .get<AreaDetailsDependency>()
                                              .areas[_selectedLocation!]
                                          as List<Map<String, dynamic>>)
                                      .map((e) => {
                                            "label": e["a_name"].toString(),
                                            "icon": Icons.map
                                          })
                                      .toList(),
                              _selectedArea, (String? newValue) {
                            setState(() => _selectedArea = newValue);
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
