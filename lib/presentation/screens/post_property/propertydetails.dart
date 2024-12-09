import 'package:flutter/material.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/buildcard.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/checkboxes.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/dropdown.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/image_pick.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/section_title.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/xtraAmenities.dart';
import 'package:my_zero_broker/presentation/widgets/ElevatedButton.dart';
import 'package:my_zero_broker/presentation/widgets/TextField.dart';

class PropertyDetailsFormScreen extends StatefulWidget {
  @override
  State<PropertyDetailsFormScreen> createState() =>
      _PropertyDetailsFormScreenState();
}

class _PropertyDetailsFormScreenState extends State<PropertyDetailsFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController plotAreaController = TextEditingController();
  final TextEditingController streetAreaController = TextEditingController();
  final TextEditingController offerPriceController = TextEditingController();
  final TextEditingController maintenanceCostController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid
      final formData = {
        "propertyDetails": {
          "propertyType": selectedPropertyType,
          "bhkType": selectedBhkType,
          "propertyAge": selectedPropertyAge,
          "carpetArea": int.tryParse(carpetAreaController.text) ?? 0,
          "totalFloor": selectedTotalFloor,
          "ownershipType": selectedOwnershipType,
          "facing": selectedFacing,
          "plotArea": int.tryParse(plotAreaController.text) ?? 0,
        },
        "localityDetails": {
          "city": selectedCity,
          "locality": selectedLocality,
          "streetArea": streetAreaController.text,
        },
        "saleResaleDetails": {
          "expectedPrice": int.tryParse(offerPriceController.text) ?? 0,
          "maintenanceCost": int.tryParse(maintenanceCostController.text) ?? 0,
          "priceNegotiable": _isPriceNegotiableSelected,
          "currentlyUnderLoan": _isCurrentlyUnderLoanSelected,
          "availableFrom": _dateController.text,
          "furnishing": selectedFurnishing,
          "parking": selectedParking,
          "kitchenType": selectedKitchenType,
          "description": descriptionController.text,
        },
        "gallery": {
          "images": [],
        },
        "amenities": {
          "bathrooms": int.tryParse(selectedBathroom ?? "0"),
          "waterSupply": selectedWaterSupply,
          "gratedSecurity": selectedGratedSecurity,
          "balcony": int.tryParse(selectedBalcony ?? "0"),
          "internetService": selectedInternetService,
        },
        "additionalInformation": {
          "khataCertificate": selectedKhataCert,
          "saleDeedCertificate": selectedSaleDeedCertificate,
          "propertyTaxPaid": selectedPropertyTax,
          "occupancyCertificate": selectedOccupancyCertificate,
        },
        "extraAmenities": {
          "amenitiesList": [],
        },
      };

      print(formData); // Debug output JSON
    } else {
      // Form is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please correct the errors in the form')),
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
        title: const Text("Post Property Details"),
        centerTitle: true,
        leading: Image.asset(
          'assets/images/my_zero_broker_logo (2).png',
          height: height * 0.08,
          width: width * 0.5,
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
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
                      ]),
                      _buildDropdownField("BHK Type", selectedBhkType,
                          ["1 RK", "1 BHK", "2 BHK", "3 BHK", "4 or more BHK"]),
                      _buildDropdownField("Property Age", selectedPropertyAge, [
                        "Under Construction/ New Construction",
                        "Ready Possession"
                      ]),
                      _buildTextField("Carpet/BuiltUp Area (Sq. Ft.)",
                          carpetAreaController),
                      _buildDropdownField("Total Floor", selectedTotalFloor,
                          ["Ground Only", "Ground+1", "Ground+2", "Ground+3"]),
                      _buildDropdownField("Ownership Type",
                          selectedOwnershipType, ["On lease", "Self Owned"]),
                      _buildDropdownField("Facing", selectedFacing, [
                        "East",
                        "West",
                        "North",
                        "South",
                        "East-South",
                        "East-North",
                        "West-South",
                        "West-North"
                      ]),
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
                          "City", selectedCity, ["AHMEDNAGER", "PUNE"]),
                      _buildDropdownField(
                          "Locality", selectedLocality, ["Select Area"]),
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
                      _buildCheckbox(
                          "Currently Under Loan", _isCurrentlyUnderLoanSelected,
                          (value) {
                        setState(() {
                          _isCurrentlyUnderLoanSelected = value ?? false;
                        });
                      }),
                      // _buildDateField(),
                      _buildDropdownField("Furnishing", selectedFurnishing,
                          ["Fully-Furnished", "Semi-Furnished", "Unfurnished"]),
                      _buildDropdownField("Parking", selectedParking,
                          ["Bike", "Car", "Bike & Car", "None"]),
                      _buildDropdownField("Kitchen Type", selectedKitchenType,
                          ["Modular", "Covered Shelves", "Open Shelves"]),
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
                        print('Images picked: ${pickedImages.length}');
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
                          ["1", "2", "3", "4", "5"]),
                      _buildDropdownField("Water Supply", selectedWaterSupply,
                          ["Corporation", "Borewell", "Both"]),
                      _buildDropdownField("Grated Security",
                          selectedGratedSecurity, ["Yes", "No"]),
                      _buildDropdownField("Balcony", selectedBalcony,
                          ["1", "2", "3", "4", "5"]),
                      _buildDropdownField("Internet Service",
                          selectedInternetService, ["Yes", "No"]),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.06),
                buildCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: "Additional Information"),
                      _buildDropdownField("Khata Certificate (7/12)",
                          selectedKhataCert, ["Yes", "No", "Don't Know"]),
                      _buildDropdownField(
                          "Sale Deed Certificate",
                          selectedSaleDeedCertificate,
                          ["Yes", "No", "Don't Know"]),
                      _buildDropdownField("Property Tax Paid",
                          selectedPropertyTax, ["Yes", "No", "Don't Know"]),
                      _buildDropdownField(
                          "Occupancy Certificate",
                          selectedOccupancyCertificate,
                          ["Yes", "No", "Don't Know"]),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.06),
                buildCard(
                  child: Column(
                    children: [
                      const SectionTitle(title: "Extra Amenities"),
                      ExtraAmenities(),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),
                Center(
                  child: Elevatedbutton(
                    text: 'Submit',
                    height: height * 0.8,
                    width: width,
                    bgcolor: Colors.red,
                    foregroundColor: Colors.white,
                    onPressed: _submitForm,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownField(
        value: value,
        onChanged: (v) {
          setState(() {
            value = v;
          });
        },
        label: label,
        fieldKey: label,
        items: items,
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
