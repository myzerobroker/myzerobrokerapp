import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/property_form/property_form_bloc.dart';
import 'package:my_zero_broker/bloc/property_form/property_form_event.dart';
import 'package:my_zero_broker/bloc/property_form/property_form_state.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/data/models/user_details_model.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/ElevatedButton.dart';
import 'package:my_zero_broker/presentation/widgets/TextField.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

import 'post_property_depenency.dart/dependency_class.dart';

class PropertyFormScreen extends StatelessWidget {
  final user = locator.get<UserDetailsDependency>().userModel;

  TextEditingController fullNamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonenocontroller = TextEditingController();
  String city = "Ahmednagar";
  String adType = "Sale/Resale";
  bool isResidential = true;

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      fullNamecontroller.text = user!.user!.name.toString();
      emailcontroller.text = user!.user!.email.toString();
      phonenocontroller.text = user!.user!.mobileNo.toString();
    }
    return BlocProvider(
      create: (_) => PropertyFormBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsPalette.appBarColor,
          centerTitle: true,
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Post Your Property",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.059,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<PropertyFormBloc, PropertyFormState>(
          builder: (context, state) {
            final bloc = BlocProvider.of<PropertyFormBloc>(context);
            final height = MediaQuery.of(context).size.height;
            final width = MediaQuery.of(context).size.width;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02),
                    Card(
                      color: const Color.fromARGB(255, 252, 231, 249),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.04),
                        child: Column(
                          children: [
                            SizedBox(height: height * 0.02),
                            Text(
                              "Property Form",
                              style: TextStyle(
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Textfield(
                              onChanged: (value) =>
                                  bloc.add(UpdateFullName(value)),
                              controller: fullNamecontroller,
                              textInputType: TextInputType.name,
                              hintText: 'Full Name',
                            ),
                            SizedBox(height: 16),
                            Textfield(
                              onChanged: (value) =>
                                  bloc.add(UpdateEmail(value)),
                              controller: emailcontroller,
                              textInputType: TextInputType.emailAddress,
                              hintText: 'Email Address',
                            ),
                            SizedBox(height: 16),
                            Textfield(
                              onChanged: (value) =>
                                  bloc.add(UpdatePhoneNumber(value)),
                              controller: phonenocontroller,
                              textInputType: TextInputType.name,
                              hintText: 'Phone No.',
                              text: '+91',
                            ),
                            SizedBox(height: 16),

                            // City Dropdown with Decoration
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: DropdownButton<String>(
                                value: state.form.city,
                                onChanged: (value) {
                                  bloc.add(UpdateCity(value!));
                                  city = value;
                                },
                                isExpanded: true,
                                underline: Container(),
                                items: [
                                  'Ahmednagar',
                                  'Pune',
                                ]
                                    .map((city) => DropdownMenuItem(
                                          value: city,
                                          child: Text(city),
                                        ))
                                    .toList(),
                              ),
                            ),
                            SizedBox(height: 16),

                            // Residential/Commercial Toggle Buttons
                            ToggleButtons(
                              isSelected: [
                                state.form.isResidential,
                                !state.form.isResidential
                              ],
                              onPressed: (index) => {
                                bloc.add(UpdateIsResidential(index == 0)),
                                isResidential = index == 0
                              },
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text('Residential'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text('Commercial'),
                                ),
                              ],
                              borderColor: Colors.grey,
                              selectedColor: Colors.white,
                              fillColor: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            SizedBox(height: 16),

                            // Ad Type Toggle Buttons (for both Residential and Commercial)
                            ToggleButtons(
                              isSelected: [
                                state.form.adType == 'Sale/Resale',
                                state.form.adType == 'Rent',
                              ],
                              onPressed: (index) {
                                bloc.add(UpdateAdType(
                                    index == 0 ? 'Sale/Resale' : 'Rent'));
                                adType = index == 0 ? 'Sale/Resale' : 'Rent';
                              },
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text('Sale/Resale'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text('Rent'),
                                ),
                              ],
                              borderColor: Colors.grey,
                              selectedColor: Colors.white,
                              fillColor: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),

                            SizedBox(height: height * 0.02),
                            Elevatedbutton(
                              bgcolor: Colors.red,
                              foregroundColor: Colors.white,
                              onPressed: () {
                                if (fullNamecontroller.text.isEmpty) {
                                  Snack.show("Full name is Required", context);
                                  return;
                                }
                                if (emailcontroller.text.isEmpty ||
                                    !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(emailcontroller.text)) {
                                  Snack.show("Enter a Valid Email", context);
                                  return;
                                }
                                if (phonenocontroller.text.isEmpty ||
                                    !RegExp(r'^\+?\d{10,}$')
                                        .hasMatch(phonenocontroller.text)) {
                                  Snack.show(
                                      "Enter a Valid Phone number", context);
                                  return;
                                }
                                if (locator.get<UserDetailsDependency>().id ==
                                    -1) {
                                  Snack.show(
                                      "Login to Post your Property ", context);
                                  return;
                                }

                                locator.get<PostPropertyDependency>().email =
                                    emailcontroller.text;
                                locator.get<PostPropertyDependency>().fullname =
                                    fullNamecontroller.text;
                                locator.get<PostPropertyDependency>().phone =
                                    phonenocontroller.text;
                                locator
                                    .get<PostPropertyDependency>()
                                    .isResidential = isResidential;
                                locator.get<PostPropertyDependency>().adType =
                                    adType;
                                locator.get<PostPropertyDependency>().city =
                                    city;
                                print(
                                    locator.get<PostPropertyDependency>().city);
                                print(locator
                                    .get<PostPropertyDependency>()
                                    .adType);
                                print(locator
                                    .get<PostPropertyDependency>()
                                    .isResidential);
                                print(locator
                                    .get<PostPropertyDependency>()
                                    .phone);
                                print(locator
                                    .get<PostPropertyDependency>()
                                    .fullname);

                                Navigator.pushNamed(
                                    context, RoutesName.propertydetailsform);
                              },
                              text: 'Start Posting Your Add',
                              height: height * 0.8,
                              width: width * 0.98,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Column(
                      children: [
                        Text(
                          "Welcome to My Zero Broker, a groundbreaking platform for posting property ads.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: width * 0.04,
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/my_zero_broker_logo (2).png',
                              height: height * 0.03,
                            ),
                            Text(
                              "MYZERO BROKER",
                              style: TextStyle(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
