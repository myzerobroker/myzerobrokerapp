import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/signup/signup_bloc.dart';
import 'package:my_zero_broker/bloc/signup/signup_event.dart';
import 'package:my_zero_broker/bloc/signup/signup_state.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/presentation/widgets/ElevatedButton.dart';
import 'package:my_zero_broker/presentation/widgets/TextField.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late SignupBloc _signupBloc;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _signupBloc = SignupBloc();
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
          backgroundColor: ColorsPalette.bgColor,
        ),
        body: BlocProvider(
          create: (context) => _signupBloc,
          child: BlocListener<SignupBloc, SignUpState>(
            listener: (context, state) {
              if (state.signupStatus == SignUpStatus.loading) {
                Snack.show('Loading...', context);
              } else if (state.signupStatus == SignUpStatus.success) {
                Snack.show(state.message, context);

                Navigator.pushNamed(context, RoutesName.homeScreen);
              } else if (state.signupStatus == SignUpStatus.error) {
                Snack.show(state.message, context);
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.02),
                    Image.asset(
                      'assets/images/my_zero_broker_logo (2).png',
                      height: height * 0.06,
                    ),
                    SizedBox(height: height * 0.02),
                    Card(
                      color: ColorsPalette.primaryColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.04),
                        child: Column(
                          children: [
                            Text(
                              "Register",
                              style: TextStyle(
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Register here and then Log in to continue.",
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
                                      controller: fullNameController,
                                      textInputType: TextInputType.text,
                                      hintText: "Full Name",
                                      onChanged: (value) {
                                        context.read<SignupBloc>().add(
                                            fullNameChanged(fullName: value));
                                      },
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Textfield(
                                      controller: emailController,
                                      textInputType: TextInputType.emailAddress,
                                      hintText: "Email Address",
                                      onChanged: (value) {
                                        context
                                            .read<SignupBloc>()
                                            .add(EmailChanged(email: value));
                                      },
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Textfield(
                                      text: "+91",
                                      controller: phoneController,
                                      textInputType: TextInputType.phone,
                                      hintText: "Enter Mobile Number",
                                      onChanged: (value) {
                                        context.read<SignupBloc>().add(
                                            phoneNoChanged(phoneNo: value));
                                      },
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Elevatedbutton(
                                      bgcolor: const Color.fromARGB(
                                          255, 209, 20, 20),
                                      foregroundColor: Colors.white,
                                      onPressed: (state.phoneNo.isNotEmpty &&
                                              state.email.isNotEmpty &&
                                              state.fullName.isNotEmpty)
                                          ? () {
                                              context
                                                  .read<SignupBloc>()
                                                  .add(SignUpApi());
                                            }
                                          : null,
                                      text: 'REGISTER',
                                      height: height * 0.8,
                                      width: width,
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: height * 0.02),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: width *
                                      0.035, 
                                  color: Colors.black, 
                                ),
                                children: [
                                  const TextSpan(
                                      text: "Already have an account? "),
                                  TextSpan(
                                    text: "Login",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontSize: width *
                                          0.035, // Match font size for alignment
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(
                                            context, RoutesName.loginScreen);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Column(
                      children: [
                        Text(
                          "Welcome to My Zero Broker, a groundbreaking firm that redefines property consultancy. We pride ourselves on operating as mediators rather than traditional property agents or brokers.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: width * 0.04,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
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
            ),
          ),
        ));
  }
}
