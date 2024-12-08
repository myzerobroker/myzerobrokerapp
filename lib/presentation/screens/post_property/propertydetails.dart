import 'dart:io';

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
  State<PropertyDetailsFormScreen> createState() => _PropertyDetailsFormScreenState();
}

class _PropertyDetailsFormScreenState extends State<PropertyDetailsFormScreen> {
  final TextEditingController carpetAreaController = TextEditingController();
  final TextEditingController plotAreaController = TextEditingController();
  final TextEditingController streetAreaController = TextEditingController();
  final TextEditingController offerPriceController = TextEditingController();
    final TextEditingController maintenanceCostController = TextEditingController();
      final TextEditingController _dateController = TextEditingController();
      final TextEditingController descriptionController = TextEditingController();


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
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Property Details"),
        centerTitle: true,
        leading:  Image.asset(
                      'assets/images/my_zero_broker_logo (2).png',
                      height: height * 0.08,
                      width: width*0.5,
                    ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCard(
                child: Column(
                  children: [
                    const SectionTitle(title: "Property Details"),
                    DropdownField(
                label: "Property Type",
                items: ["Row House","Individual Villa/Bunglow","Farm House","Flat","Twin Bunglow"],
                fieldKey: "property_type",
              ),
              SizedBox(height: height * 0.01),
              DropdownField(
                label: "BHK Type",
                items: ["1 RK","1 BHK", "2 BHK", "3 BHK" ,"4 or more BHK"],
                fieldKey: "bhk",
              ),
               SizedBox(height: height * 0.01),
              DropdownField(
                label: "Property Age",
                items: ["Under Construction/ New Construction", "Ready Possession"],
                fieldKey: "property_age",
              ),
               SizedBox(height: height * 0.01),
              Textfield(
              controller: carpetAreaController,
              textInputType: TextInputType.text, // Specify your input type
              hintText: 'Carpet/BuiltUp Area (Sq. Ft.)', // Set hint text
              onChanged: (value) {
               
                print(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Carpet/BuiltUp Area';
                }
                return null;
              },),
              SizedBox(height: height * 0.01),
               DropdownField(
                label: "Total Floor",
                items: ["Ground Only", "Ground+1","Ground+2","Ground+3"],
                fieldKey: "total_floor",
              ),
               SizedBox(height: height * 0.01),
                DropdownField(
                label: "Ownership Type",
                items: ["On lease", "Self Owned"],
                fieldKey: "ownership_type",
              ),
               SizedBox(height: height * 0.01),
                DropdownField(
                label: "Facing",
                items: ["East", "West","North","South","East-South","East-North","West-South","West-North"],
                fieldKey: "facing",
              ),
              SizedBox(height: height * 0.01),
               Textfield(
              controller: plotAreaController,
              textInputType: TextInputType.text,
              hintText: 'Enter Plot Area (Sq. Ft.)',
              onChanged: (value) {
               
                print(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Enter Plot Area (Sq. Ft.)';
                }
                return null;
              },),
                  ],
                ),
              ),
              
              SizedBox(height: height * 0.06),
               buildCard(
                 child: Column(
                   children: [
                     const SectionTitle(title: "Locality Details"),
                      DropdownField(
                label: "City",
                items: ["AHMEDNAGER","PUNE"],
                fieldKey: "city",
              ),
              SizedBox(height: height * 0.01),
              DropdownField(
                label: "Locality",
                items: ["Select Area"],
                fieldKey: "locality",
              ),
              SizedBox(height: height * 0.01),
                Textfield(
              controller: streetAreaController,
              textInputType: TextInputType.text, 
              hintText: 'Street/Area', 
              onChanged: (value) {
               
                print(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter street/area';
                }
                return null;
              },),
                   ],
                 ),
               ),
              

                SizedBox(height: height * 0.06),

                 Column(
                   children: [
                     const SectionTitle(title: "Sale/Resale Details"),
                         Textfield(
              controller: offerPriceController,
              textInputType: TextInputType.text, 
              hintText: 'Enter Expected Price ', 
           
              onChanged: (value) {
               
                print(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Expected Price ';
                }
                return null;
              },),
              SizedBox(height: height * 0.01),

               Textfield(
              controller: maintenanceCostController,
              textInputType: TextInputType.text, 
              hintText: 'Enter Maintenance Cost (/month)',
              onChanged: (value) {
               
                print(value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Maintenance Cost';
                }
                return null;
              },),
              SizedBox(height: height * 0.01),
              CustomCheckbox(
                            label: "Price Negotiable",
                            initialValue: _isPriceNegotiableSelected,
                            onChanged: (bool? value) {
                              setState(() {
              _isPriceNegotiableSelected = value ?? false;
                              });
                            },
                          ),
              
                           CustomCheckbox(
                            label: "Currently Under Loan",
                            initialValue: _isCurrentlyUnderLoanSelected,
                            onChanged: (bool? value) {
                              setState(() {
              _isCurrentlyUnderLoanSelected = value ?? false;
                              });
                            },
                          ),
              SizedBox(height: height * 0.01),
              TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Available Form',
                hintText: 'Select a date',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              readOnly: true, 
              onTap: () => _pickDate(context), 
            ),

             SizedBox(height: height * 0.01),
              DropdownField(
                label: "Furnishing",
                items: ["Fully-Furnished","Semi-Furnished","Unfurnished"],
                fieldKey: "furnishing",
              ),
              SizedBox(height: height * 0.01),
               DropdownField(
                label: "Parking",
                items: ["Bike","Car","Bike & Car","None"],
                fieldKey: "parking",
              ),
              SizedBox(height: height * 0.01),
               DropdownField(
                label: "Kitchen Type",
                
                items: ["Modular","Covered Shelves","Open Shelves"],
                fieldKey: "furnishing",
              ),
              SizedBox(height: height * 0.01),
              
             Textfield(
              controller: descriptionController,
              textInputType: TextInputType.text, // Specify your input type
              hintText: 'Description',
              onChanged: (value) {
               
                print(value);
              },
              ),
                   ],
                 ),

              

                 SizedBox(height: height * 0.06),
                buildCard(
  child: Column(
    children: [
      const SectionTitle(title: "Gallery"),
      GalleryImagePicker(
        onImagesPicked: (List<File> pickedImages) {

          print('Images picked: ${pickedImages.length}');
        },
      ),
    ],
  ),
),

             
                 

                  SizedBox(height: height * 0.06),

              buildCard(
                child: Column(
                  children: [
                    const SectionTitle(title: "Amenities"),
                     DropdownField(
                label: "Bathroom(s)",
                items: ["1", "2", "3","4","5"],
                fieldKey: "bathroom",
              ),
                SizedBox(height: height * 0.01),
              DropdownField(
                label: "Water Supply",
                items: ["Corporation", "Borewell","Both"],
                fieldKey: "water_supply",
              ),
                SizedBox(height: height * 0.01),
                 DropdownField(
                label: "Grated Security",
                items: ["Yes","No"],
                fieldKey: "grated_security",
              ),
                SizedBox(height: height * 0.01),
                 DropdownField(
                label: "Balcony",
                items: ["1","2","3","4","5"],
                fieldKey: "blocony",
              ),
                SizedBox(height: height * 0.01),
                  DropdownField(
                label: "Internet Service",
                items: ["Yes","No"],
                fieldKey: "internet_service",
              ),
                  ],
                ),
              ),
             
                SizedBox(height: height * 0.06),
              buildCard(
                child: Column(
                  children: [
                    const SectionTitle(title: "Additional Information"),
                         DropdownField(
                label: "Do you have Khata Certificate (7/12)?",
                items: ["Yes", "No","Don't Know"],
                fieldKey: "khata_cert",
              ),
              SizedBox(height: height * 0.01),
              DropdownField(
                label: "Do you have Sale Deed Certificate?",
                items: ["Yes", "No","Don't Know"],
                fieldKey: "sale_deed_certificate",
              ),
              SizedBox(height: height * 0.01),
              DropdownField(
                label: "Have you paid Property Tax?",
                items: ["Yes", "No","Don't Know"],
                fieldKey: "property_tax",
              ),
              SizedBox(height: height * 0.01),
              DropdownField(
                label: "Do you have Occupancy Certificate?",
                items: ["Yes", "No","Don't Know"],
                fieldKey: "occupancy_certificate",
              ),
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

                
                 
              SizedBox(height: height*0.02),
              Center(
                child: Elevatedbutton(
                  text: 'Submit',
                  height: height*0.7,
                  width: width,
                  
                  onPressed: () {
                   
                    print("Form Submitted");
                  },
                
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

