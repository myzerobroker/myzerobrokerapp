import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/post_builder/post_builder_bloc.dart';
import 'package:my_zero_broker/bloc/post_builder/post_builder_event.dart';
import 'package:my_zero_broker/bloc/post_builder/post_builder_state.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
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

  Widget _buildDropdownField(String label, String? value, List<String> items, Function(String?) onChanged) {
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

         "user_id": 56,
    "builder_name": builderNameController.text,
    "city_id": _selectedLocation,
    "locality_id": 202,
    "area": _selectedArea,
    "1st_contact": contactNo1Controller.text,
    "2nd_contact": contactNo2Controller.text,
    "email": EmailController,
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
        title: const Text("Post your Plot/Farmland"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: BlocListener<PostBuildersDetailsBloc, PostBuildersDetailsState>(
        listener: (context, state) {
          if (state is PostBuilderDetailsSuccessState) {
            Snack.show(state.successMessage, context);
          } else if (state is PostBuilderDetailsFailureState ) {
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
                        SectionTitle(title: "Provide Your Contact Information"),
                        _buildTextField("Builder/Developer Name", builderNameController, true),
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
                      _buildTextField("Street/Area", streetAreaController, true),
                        _buildTextField("1st Contact  Number", contactNo1Controller, true),
                        _buildTextField("2nd Contact Number", contactNo2Controller, true),
                        _buildTextField("Email", EmailController, true),
                        _buildTextField("GST/TAX Number(Optional)", gstController, false),
                     
                        
                        
                        
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: "Provide Your Property Information"),
                        _buildDropdownField("Plot Type", selectedPlotType, ["Flat", "Independent House/Villa", "Farm House", "Row House", "Twin Bunglow"], (val) {
                          setState(() {
                            selectedPlotType = val;
                          });
                        }),
                      _buildTextField("Property/Apartment/Building Name", buildingNameController, false),
                      _buildTextField("Total Floors/Stories", totalfloorsController, false),
                      _buildTextField("Number of Units", numberofUnitsController, false),
                    ],
                  ),
                ),
              
                  
                  SizedBox(height: height * 0.06),
                SizedBox(height: 20),
                Center(
                  child:
                 
                    ElevatedButton(
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
                             final postbuilder = _submitForm(context);
                          },
                        )
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
