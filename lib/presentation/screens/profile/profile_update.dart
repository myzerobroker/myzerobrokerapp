import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/signup/signup_bloc.dart';
import 'package:my_zero_broker/bloc/signup/signup_event.dart';
import 'package:my_zero_broker/bloc/signup/signup_state.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/ElevatedButton.dart';
import 'package:my_zero_broker/presentation/widgets/TextField.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final user = locator.get<UserDetailsDependency>().userModel;
  late SignupBloc _signupBloc;

  TextEditingController fullNamecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonenocontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _signupBloc = SignupBloc();
    if (user != null) {
      fullNamecontroller.text = user!.user!.name.toString();
      emailcontroller.text = user!.user!.email.toString();
      phonenocontroller.text = user!.user!.mobileNo.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsPalette.bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "REAL ESTATE, ",
                style: TextStyles.subHeadingStyle.copyWith(
                  color: ColorsPalette.textPrimaryColor,
                  fontSize: width * 0.059,
                ),
              ),
              TextSpan(
                text: "SIMPLIFIED",
                style: TextStyles.subHeadingStyle.copyWith(
                  color: ColorsPalette.primaryColor,
                  fontSize: width * 0.059,
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: ColorsPalette.appBarColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorsPalette.primaryColor.withOpacity(0.6),
              ColorsPalette.bgColor.withOpacity(0.8),
              Colors.white,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: BlocProvider(
          create: (context) => _signupBloc,
          child: BlocListener<SignupBloc, SignUpState>(
            listener: (context, state) {
              if (state.updateStatus == UpdateStatus.loading) {
                Snack.show('Updating profile...', context);
              } else if (state.updateStatus == UpdateStatus.success) {
                Snack.show(state.message, context);
              } else if (state.updateStatus == UpdateStatus.error) {
                Snack.show(state.message, context);
              }
            },
            listenWhen: (previous, current) => previous.updateStatus != current.updateStatus,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.05),
                    Image.asset(
                      'assets/images/my_zero_broker_logo (2).png',
                      height: height * 0.1,
                    ),
                    SizedBox(height: height * 0.02),
                    Card(
                      color: ColorsPalette.cardBgColor.withOpacity(0.95),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: height * 0.02),
                            Text(
                              "Update Profile",
                              textAlign: TextAlign.center,
                              style: TextStyles.headingStyle.copyWith(
                                fontSize: width * 0.07,
                              ),
                            ),
                           
                            Text(
                              "Update your profile here",
                              textAlign: TextAlign.center,
                              style: TextStyles.bodyStyle.copyWith(
                                color: ColorsPalette.textSecondaryColor,
                                fontSize: width * 0.035,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            BlocBuilder<SignupBloc, SignUpState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    Textfield(
                                      controller: fullNamecontroller,
                                      textInputType: TextInputType.text,
                                      hintText: "Full Name",
                                      onChanged: (value) {},
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Textfield(
                                      controller: emailcontroller,
                                      textInputType: TextInputType.emailAddress,
                                      hintText: "Email Address",
                                      onChanged: (value) {},
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Textfield(
                                      controller: phonenocontroller,
                                      textInputType: TextInputType.phone,
                                      hintText: "Enter Mobile Number",
                                      onChanged: (value) {},
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Elevatedbutton(
                                      bgcolor: ColorsPalette.primaryColor,
                                      foregroundColor: ColorsPalette.cardBgColor,
                                      text: 'UPDATE',
                                      height: height * 0.78,
                                      width: width,
                                      onPressed: () {
                                        final fullName = fullNamecontroller.text.trim();
                                        final email = emailcontroller.text.trim();
                                        final phoneNo = phonenocontroller.text.trim();

                                        if (fullName.isEmpty || email.isEmpty || phoneNo.isEmpty) {
                                          Snack.show('Please fill all fields!', context);
                                          return;
                                        }

                                        context.read<SignupBloc>().add(
                                          UpdateProfileApi(
                                            fullName: fullName,
                                            email: email,
                                            phoneNo: phoneNo,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: height * 0.02),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Column(
                      children: [
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/my_zero_broker_logo (2).png',
                              height: height * 0.025,
                            ),
                            SizedBox(width: width * 0.015),
                            Text(
                              "MYZERO BROKER",
                              style: TextStyles.subHeadingStyle.copyWith(
                                color: ColorsPalette.primaryColor,
                                fontSize: width * 0.045,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      "© 2023 My Zero Broker. All rights reserved.",
                      style: TextStyles.bodyStyle.copyWith(
                        color: ColorsPalette.textSecondaryColor,
                        fontSize: width * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}