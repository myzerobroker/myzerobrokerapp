import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/login/login_bloc.dart';
import 'package:my_zero_broker/bloc/user_details/fetch_user_details_bloc.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/data/user_id.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/ElevatedButton.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late LoginBloc _loginBloc;
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.0),
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: height * 0.02),
                              Text(
                                "Verify OTP",
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
                                    current.otp != previous.otp,
                                builder: (context, state) {
                                  return Form(
                                    key: _formKey,
                                    child: Pinput(
                                      controller: otpController,
                                      length: 6,
                                      onChanged: (value) {
                                        context.read<LoginBloc>().add(otpChanged(
                                            otp: value)); // Send OTP as string
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter OTP";
                                        }
                                        return null;
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              BlocListener<FetchUserDetailsBloc,
                                  FetchUserDetailsState>(
                                listener: (context, state) {
                                  if (state is FetchUserDetailsLoaded) {
                                    Snack.show(state.userDetails.message!, context);
                                    Navigator.pushNamed(
                                        context, RoutesName.locationFetch);
                                  } else if (state is FetchUserDetailsError) {
                                    Snack.show(state.message, context);
                                  } else {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                            backgroundColor: Colors.transparent,
                                          );
                                        });
                                  }
                                },
                                child: BlocListener<LoginBloc, LoginState>(
                                  listener: (context, state) async {
                                    if (state.loginStatus ==
                                        LoginStatus.otpVerificationSuccess) {
                                      SharedPreferences sp =
                                          await SharedPreferences.getInstance();
                                      sp.setInt("userId", locator.get<UserId>().id);
                                      print(locator.get<UserId>().id);
                                      context
                                          .read<FetchUserDetailsBloc>()
                                          .add(FetchDetailsEvent());
                                    } else if (state.loginStatus ==
                                        LoginStatus.otpVerificationFailure) {
                                      Snack.show(state.message, context);
                                    }
                                  },
                                  child: BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, state) {
                                      return Elevatedbutton(
                                        bgcolor: ColorsPalette.primaryColor,
                                        foregroundColor: ColorsPalette.cardBgColor,
                                        text: 'VERIFY OTP',
                                        height: height * 0.78,
                                        width: width * 1,
                                        onPressed: () {
                                          if (_formKey.currentState?.validate() ??
                                              false) {
                                            String otp = otpController.text; // Treat OTP as string
                                            context
                                                .read<LoginBloc>()
                                                .add(VerifyOtpApi(state.userId));
                                          }
                                        },
                                      );
                                    },
                                  ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
                        textAlign: TextAlign.center,
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
      ),
    );
  }
}