import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/post_builder/post_builder_bloc.dart';
import 'package:my_zero_broker/bloc/post_builder/post_builder_event.dart';
import 'package:my_zero_broker/bloc/post_builder/post_builder_state.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/screens/post_property/post_property_depenency.dart/dependency_class.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/buildcard.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/section_title.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';

class PostBuilderDetails extends StatefulWidget {
  @override
  State<PostBuilderDetails> createState() => _PostBuilderDetailsState();
}

class _PostBuilderDetailsState extends State<PostBuilderDetails> {
  final locations = locator.get<AreaDetailsDependency>().cityDetails.map((e) {
    return {
      "label": e.cName,
      "icon": Icons.location_city,
      "id": e.id.toString()
    };
  }).toList();

  String? _selectedLocation;
  String? _selectedArea;
  int? locality_id;
  int? cityId;
  late List<Map<String, dynamic>> areas;

  @override
  void initState() {
    super.initState();
    areas = locator
        .get<AreaDetailsDependency>()
        .areas[locator.get<PostPropertyDependency>().city.toUpperCase()]!
        .toList() as List<Map<String, dynamic>>;
    print(areas);
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController builderNameController = TextEditingController();
  final TextEditingController contactNo1Controller = TextEditingController();
  final TextEditingController contactNo2Controller = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController buildingNameController = TextEditingController();
  final TextEditingController streetAreaController = TextEditingController();
  final TextEditingController totalfloorsController = TextEditingController();
  final TextEditingController numberofUnitsController = TextEditingController();

  String? selectedPlotType;

  Widget _buildDropdownFieldWithIcons(String label, String? value,
      List<Map<String, dynamic>> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
      final Map<String, dynamic> postbuilderDeatils = {
        "user_id": locator.get<UserDetailsDependency>().id,
        "builder_name": builderNameController.text,
        "city_id": cityId.toString() ?? "0",
        "locality_id": locality_id.toString() ?? "0",
        "area": _selectedArea,
        "1st_contact": contactNo1Controller.text,
        "2nd_contact": contactNo2Controller.text,
        "email": EmailController.text,
        "gst_number": gstController.text,
        "building_name": buildingNameController.text,
        "total_floors": totalfloorsController.text,
        "no_of_flats": numberofUnitsController.text,
        "property_type": locator.get<PostPropertyDependency>().isResidential
            ? "Residential"
            : "Commercial",
        "purpose": locator.get<PostPropertyDependency>().adType,
        "plot_type": selectedPlotType,
      };

      BlocProvider.of<PostBuildersDetailsBloc>(context)
          .add(PostBuilderEventToApi(propertyDetails: postbuilderDeatils));
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
          title: const Text("Builder's Plan"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 238, 123, 152),
        ),
        body: BlocListener<PostBuildersDetailsBloc, PostBuildersDetailsState>(
          listener: (context, state) {
            if (state is PostBuilderDetailsSuccessState) {
              Snack.show(state.successMessage, context);
            } else if (state is PostBuilderDetailsFailureState) {
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle(
                              title: "Provide Your Contact Information"),
                          _buildTextField("Builder/Developer Name",
                              builderNameController, true),
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
                                areas = locator
                                    .get<AreaDetailsDependency>()
                                    .areas[val]!
                                    .toList() as List<Map<String, dynamic>>;
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
                          _buildTextField("1st Contact  Number",
                              contactNo1Controller, true),
                          _buildTextField(
                              "2nd Contact Number", contactNo2Controller, true),
                          _buildTextField("Email", EmailController, true),
                          _buildTextField(
                              "GST/TAX Number(Optional)", gstController, false),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionTitle(
                              title: "Provide Your Property Information"),
                          _buildDropdownField("Plot Type", selectedPlotType, [
                            "Flat",
                            "Independent House/Villa",
                            "Farm House",
                            "Row House",
                            "Twin Bunglow"
                          ], (val) {
                            setState(() {
                              selectedPlotType = val;
                            });
                          }),
                          _buildTextField("Property/Apartment/Building Name",
                              buildingNameController, false),
                          _buildTextField("Total Floors/Stories",
                              totalfloorsController, false),
                          _buildTextField("Number of Units",
                              numberofUnitsController, false),
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
                        _submitForm(context);
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
