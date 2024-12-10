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
import 'package:my_zero_broker/utils/constant/colors.dart';

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
                          SizedBox(height: height * 0.02),
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: width * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          const Text(
                            "Welcome back! Log in to continue.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 90, 42, 42)),
                          ),
                          SizedBox(height: height * 0.02),
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
    ),
   Flexible(
  child: RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: width * 0.04, // Ensure consistent font size
        color: Colors.black, // Set default text color
      ),
      children: [
        TextSpan(text: "I agree with the "),
        TextSpan(
          text: "terms and conditions.",
          style: TextStyle(
            color: Colors.blue,
            fontSize: width * 0.04, 
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushNamed(context, RoutesName.termsAndCondition);
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
                                  bgcolor: const Color.fromARGB(255, 209, 20, 20),
                                  foregroundColor: Colors.white,
                                  text: 'SEND OTP',
                                  height:  height * 0.8,
                                      width: width,
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      final phoneNo = phoneNoController.text;

                                      if (phoneNo.isNotEmpty) {
                                        context.read<LoginBloc>().add(
                                              phoneNoChanged(phoneNo: phoneNo),
                                            );
                                        context
                                            .read<LoginBloc>()
                                            .add(LoginApi());
                                      } else {
                                        // Handle invalid phone number input (empty or invalid number)
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
    style: TextStyle(
      fontSize: width * 0.035, // Ensure consistent font size for all text
      color: Colors.black, // Default text color
    ),
    children: [
      const TextSpan(text: "Don't have an account? "),
      TextSpan(
        text: "Register",
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: width * 0.035, // Match font size for alignment
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.pushReplacementNamed(context, RoutesName.signUpScreen);
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
      ),
    );
  }
}
