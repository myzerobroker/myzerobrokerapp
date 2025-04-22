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
import 'package:my_zero_broker/utils/constant/theme.dart';

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
      backgroundColor:  ColorsPalette.bgColor, 
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorsPalette.primaryColor.withOpacity(0.7),
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
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.05),
                    Image.asset(
                      'assets/images/my_zero_broker_logo (2).png',
                      height: height * 0.1,
                    ),
                    SizedBox(height: height * 0.03),
                    Card(
                      elevation: 8,
                      color: ColorsPalette.cardBgColor.withOpacity(0.95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.04),
                        child: Column(
                          children: [
                            SizedBox(height: height * 0.02),
                            Text(
                              "Register",
                              style: TextStyles.headingStyle.copyWith(
                                fontSize: width * 0.05,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: const Offset(0.5, 0.5),
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.015),
                            Text(
                              "Register here and then Log in to continue.",
                              textAlign: TextAlign.center,
                              style: TextStyles.bodyStyle.copyWith(
                                color: ColorsPalette.textSecondaryColor,
                                fontStyle: FontStyle.italic,
                                fontSize: width * 0.035,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
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
                                    SizedBox(height: height * 0.03),
                                    Elevatedbutton(
                                      bgcolor: ColorsPalette.primaryColor,
                                      foregroundColor: ColorsPalette.cardBgColor,
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
                                      height: height * 0.78,
                                      width: width * 1,
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: height * 0.02),
                            RichText(
                              text: TextSpan(
                                style: TextStyles.bodyStyle.copyWith(
                                  fontSize: width * 0.032,
                                ),
                                children: [
                                  const TextSpan(text: "Already have an account? "),
                                  TextSpan(
                                    text: "Login",
                                    style: TextStyles.bodyStyle.copyWith(
                                      color: ColorsPalette.primaryColor,
                                      decoration: TextDecoration.underline,
                                      fontSize: width * 0.032,
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
                    SizedBox(height: height * 0.03),
                    Column(
                      children: [
                        Text(
                          "Welcome to My Zero Broker, a groundbreaking firm that redefines property consultancy. We pride ourselves on operating as mediators rather than traditional property agents or brokers.",
                          textAlign: TextAlign.center,
                          style: TextStyles.bodyStyle.copyWith(
                            color: ColorsPalette.textSecondaryColor,
                            fontSize: width * 0.035,
                          ),
                        ),
                        SizedBox(height: height * 0.04),
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