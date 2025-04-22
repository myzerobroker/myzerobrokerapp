import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/login/login_bloc.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/data/user_id.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/ElevatedButton.dart';
import 'package:my_zero_broker/presentation/widgets/TextField.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;
  final TextEditingController phoneNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _terms = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {},
      child: Scaffold(
        backgroundColor:  ColorsPalette.bgColor,  
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
            create: (context) => _loginBloc,
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
                    SizedBox(height: height * 0.09),
                    Card(
                      color: ColorsPalette.cardBgColor.withOpacity(0.95),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.03),
                        child: Column(
                          children: [
                            SizedBox(height: height * 0.02),
                            Text(
                              "Login",
                              style: TextStyles.headingStyle.copyWith(
                                fontSize: width * 0.05,
                              ),
                            ),

                            SizedBox(height: height * 0.015),
                            Text(
                              "Welcome back! Log in to continue.",
                              textAlign: TextAlign.center,
                              style: TextStyles.bodyStyle.copyWith(
                                color: ColorsPalette.textSecondaryColor,
                                fontSize: width * 0.035,
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            BlocBuilder<LoginBloc, LoginState>(
                              buildWhen: (previous, current) =>
                                  current.phoneNo != previous.phoneNo,
                              builder: (context, state) {
                                return Form(
                                  key: _formKey,
                                  child: Textfield(
                                    text: '+91',
                                    controller: phoneNoController,
                                    hintText: "Enter Mobile Number",
                                    textInputType: TextInputType.phone,
                                    onChanged: (value) {},
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter a phone number";
                                      }
                                      if (!RegExp(r"^[0-9]{10}$")
                                          .hasMatch(value)) {
                                        return "Enter a valid phone number";
                                      }
                                      return null;
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: height * 0.02),
                            Row(
                              children: [
                                Checkbox(
                                  value: _terms,
                                  onChanged: (value) {
                                    setState(() {
                                      _terms = value!;
                                    });
                                  },
                                  activeColor: ColorsPalette.primaryColor,
                                ),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyles.bodyStyle,
                                      children: [
                                        TextSpan(text: "I agree with the "),
                                        TextSpan(
                                          text: "terms and conditions.",
                                          style: TextStyles.bodyStyle.copyWith(
                                            color: ColorsPalette.primaryColor,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushNamed(
                                                  context, RoutesName.termsAndCondition);
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            BlocListener<LoginBloc, LoginState>(
                              listener: (context, state) {
                                if (state.loginStatus == LoginStatus.error) {
                                  Snack.show(state.message, context);
                                }
                                if (state.loginStatus == LoginStatus.loading) {
                                  Snack.show("Authenticating", context);
                                }
                                if (state.loginStatus == LoginStatus.success) {
                                  Snack.show("OTP sent successfully", context);
                                  print(state.loginStatus);
                                  locator.get<UserId>().id = state.userId;
                                  print(locator.get<UserId>().id);
                                  if (state.loginStatus == LoginStatus.success) {
                                    Navigator.pushReplacementNamed(
                                        context, RoutesName.otpScreen);
                                  }
                                }
                              },
                              child: BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  return Elevatedbutton(
                                    bgcolor: ColorsPalette.primaryColor,
                                    foregroundColor: ColorsPalette.cardBgColor,
                                    text: 'SEND OTP',
                                    height: height * 0.78,
                                    width: width * 1,
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        final phoneNo = phoneNoController.text;
                                        if (_terms == false) {
                                          Snack.show(
                                              "Please agree to the terms and conditions",
                                              context);
                                        } else if (phoneNo.isNotEmpty && _terms == true) {
                                          context.read<LoginBloc>().add(
                                                phoneNoChanged(phoneNo: phoneNo),
                                              );
                                          context
                                              .read<LoginBloc>()
                                              .add(LoginApi());
                                        } else {
                                          Snack.show(
                                              "Please enter a valid phone number",
                                              context);
                                        }
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            RichText(
                              text: TextSpan(
                                style: TextStyles.bodyStyle.copyWith(
                                  fontSize: width * 0.032,
                                ),
                                children: [
                                  const TextSpan(text: "Don't have an account? "),
                                  TextSpan(
                                    text: "Register",
                                    style: TextStyles.bodyStyle.copyWith(
                                      color: ColorsPalette.primaryColor,
                                      decoration: TextDecoration.underline,
                                      fontSize: width * 0.032,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(
                                            context, RoutesName.signUpScreen);
                                      },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.02),
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