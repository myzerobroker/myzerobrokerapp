import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/login/login_bloc.dart';
import 'package:my_zero_broker/bloc/user_details/fetch_user_details_bloc.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/data/user_id.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/ElevatedButton.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';
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
        backgroundColor: ColorsPalette.primaryColor,
      ),
      body: BlocProvider(
        create: (context) => _loginBloc,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.02),
                Image.asset(
                  'assets/images/my_zero_broker_logo (2).png',
                  height: height * 0.12,
                ),
                SizedBox(height: height * 0.02),
                Card(
                  color: ColorsPalette.bgColor,
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
                          "Verify OTP",
                          style: TextStyle(
                            fontSize: width * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        const Text(
                          "Welcome back! Log in to continue.",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Color.fromARGB(255, 90, 42, 42)),
                        ),
                        SizedBox(height: height * 0.02),
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
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      String otp = otpController
                                          .text; // Treat OTP as string
                                      context
                                          .read<LoginBloc>()
                                          .add(VerifyOtpApi(state.userId));
                                    }
                                  },
                                  text: 'VERIFY OTP',
                                  height: height * 0.8,
                                  width: width * 0.99999,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, RoutesName.homeScreen);
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: "Register",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: width * 0.04,
                                  ),
                                ),
                              ],
                            ),
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
        ),
      ),
    );
  }
}
