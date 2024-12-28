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
import 'package:my_zero_broker/utils/constant/colors.dart';

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
      appBar: AppBar(
        centerTitle: true,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "REAL ESTATE, ",
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.059,
                ),
              ),
              TextSpan(
                text: "SIMPLIFIED",
                style: TextStyle(
                  color: const Color.fromARGB(255, 116, 0, 0),
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.059,
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: ColorsPalette.appBarColor,
      ),
      body: BlocProvider(
        create: (context) => _signupBloc,
        child:BlocListener<SignupBloc, SignUpState>(
  listener: (context, state) {
    if (state.updateStatus == UpdateStatus.loading) {
      Snack.show('Updating profile...', context);
    } else if (state.updateStatus == UpdateStatus.success) {
      Snack.show(state.message, context);
    } else if (state.updateStatus == UpdateStatus.error) {
      Snack.show(state.message, context);
    }
      listenWhen: (previous, current) => previous.updateStatus != current.updateStatus;
  },

          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.02),
                  Image.asset(
                    'assets/images/my_zero_broker_logo (2).png',
                    height: height * 0.13,
                  ),
                  SizedBox(height: height * 0.02),
                  Card(
                    color: ColorsPalette.cardColor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.04),
                      child: Column(
                        children: [
                          Text(
                            "Update Profile",
                            style: TextStyle(
                              fontSize: width * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Update your profile here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 90, 42, 42)),
                          ),
                          SizedBox(height: height * 0.02),
                          BlocBuilder<SignupBloc, SignUpState>(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  Textfield(
                                    controller: fullNamecontroller,
                                    textInputType: TextInputType.text,
                                    hintText: "Full Name",
                                    onChanged: (value) {
                                     
                                    },
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Textfield(
                                    controller: emailcontroller,
                                    textInputType: TextInputType.emailAddress,
                                    hintText: "Email Address",
                                    onChanged: (value) {
                                      
                                    },
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Textfield(
                                    controller: phonenocontroller,
                                    textInputType: TextInputType.phone,
                                    hintText: "Enter Mobile Number",
                                    onChanged: (value) {
                                   
                                    },
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Elevatedbutton(
                                    bgcolor: const Color.fromARGB(255, 209, 20, 20),
                                    foregroundColor: Colors.white,
                                   onPressed: () {
  final fullName = fullNamecontroller.text.trim();
  final email = emailcontroller.text.trim();
  final phoneNo = phonenocontroller.text.trim();

  // Check if the text fields are not empty
  if (fullName.isEmpty || email.isEmpty || phoneNo.isEmpty) {
    Snack.show('Please fill all fields!', context);
    return; // Early return if fields are empty
  }

  // Trigger the event with the entered data
  context.read<SignupBloc>().add(
    UpdateProfileApi(
      fullName: fullName,
      email: email,
      phoneNo: phoneNo,
    ),
    
  );
 
},

                                    text: 'UPDATE',
                                    height: height * 0.8,
                                    width: width,
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
                  SizedBox(height: height * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
