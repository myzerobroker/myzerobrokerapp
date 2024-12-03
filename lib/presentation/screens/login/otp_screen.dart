import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/login/login_bloc.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/presentation/widgets/TextField.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

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
        backgroundColor: ColorsPalette.appBarColor,
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
                  color: ColorsPalette.cardColor,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/my_zero_broker_logo (2).png',
                          height: height * 0.06,
                        ),
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
                              child: Textfield(
                                text: '+91',
                                controller: otpController,
                                hintText: "Enter OTP",
                                textInputType: TextInputType.number,
                                onChanged: (value) {
                                  context
                                      .read<LoginBloc>()
                                      .add(otpChanged(otp: value));
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
                       
                        BlocListener<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state.loginStatus ==
                                    LoginStatus.otpVerificationSuccess) {
                                  // OTP verification success
                                  Navigator.pushNamed(
                                      context, RoutesName.homeScreen);
                                } else if (state.loginStatus ==
                                    LoginStatus.otpVerificationFailure) {
                                  // OTP verification failure
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'OTP verification failed: ${state.message}')),
                                  );
                                }
                              },

                          child: BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () {
  if (_formKey.currentState?.validate() ?? false) {
    // Convert the phone number to a string (instead of an integer)
   final otp =
                                        int.tryParse(otpController.text);
                                    if (otp != null) {
                                      // Pass OTP and trigger event
                                      context.read<LoginBloc>().add(otpChanged(
                                          otp: otp
                                              .toString())); // Pass integer OTP
                                      context
                                          .read<LoginBloc>()
                                          .add(VerifyOtpApi());
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Invalid OTP. Please enter a valid number.')),
                                      );
                                    }
                                  }
                                },


                                child: Text('VERIFY OTP'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(width, height * 0.08),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesName.homeScreen);
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
