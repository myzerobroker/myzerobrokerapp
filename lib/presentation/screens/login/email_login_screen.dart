import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/login/login_bloc.dart';
import 'package:my_zero_broker/bloc/user_details/fetch_user_details_bloc.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/data/user_id.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/widgets/ElevatedButton.dart';
import 'package:my_zero_broker/presentation/widgets/TextField.dart';
// import 'package:my_zero_broker/presentation/widgets/TextField.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  late LoginBloc _loginBloc;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _terms = false;
  bool _obscurePassword = true;

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
        backgroundColor: ColorsPalette.bgColor,
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
                                  current.email != previous.email ||
                                  current.password != previous.password,
                              builder: (context, state) {
                                return Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Textfield(
                                        controller: emailController,
                                        hintText: "Enter Email",
                                        textInputType:
                                            TextInputType.emailAddress,
                                        onChanged: (value) {},
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter an email";
                                          }
                                          if (!RegExp(
                                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                              .hasMatch(value)) {
                                            return "Enter a valid email address";
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: height * 0.02),
                                      Textfield(
                                        controller: passwordController,
                                        hintText: "Enter Password",
                                        obscureText: _obscurePassword,
                                        textInputType:
                                            TextInputType.visiblePassword,
                                        onChanged: (value) {},
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: ColorsPalette
                                                .textSecondaryColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter a password";
                                          }
                                          if (value.length < 6) {
                                            return "Password must be at least 6 characters";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
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
                                              Navigator.pushNamed(context,
                                                  RoutesName.termsAndCondition);
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
                              listener: (context, state) async {
                                if (state.loginStatus == LoginStatus.error) {
                                  Snack.show(state.message, context);
                                }
                                if (state.loginStatus == LoginStatus.loading) {
                                  Snack.show("Authenticating", context);
                                }
                                if (state.loginStatus == LoginStatus.success) {
                                  Snack.show("Login successful", context);
                                 
                                  locator.get<UserId>().id = state.userId;
                                    print("Updated UserId: ${locator.get<UserId>().id}");

                                    // Save the userId in SharedPreferences with the correct key
                                    SharedPreferences sp =
                                        await SharedPreferences.getInstance();
                                    await sp.setInt("userId", state.userId);
                                    print("Saved user_id: ${state.userId}");
                                      context
                                          .read<FetchUserDetailsBloc>()
                                          .add(FetchDetailsEvent());
                                  Navigator.pushReplacementNamed(
                                      context, RoutesName.homeScreen);
                                }
                              },
                              child: BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  return Elevatedbutton(
                                    bgcolor: ColorsPalette.primaryColor,
                                    foregroundColor: ColorsPalette.cardBgColor,
                                    text: 'LOGIN',
                                    height: height * 0.78,
                                    width: width * 1,
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        final email = emailController.text;
                                        final password =
                                            passwordController.text;
                                        if (_terms == false) {
                                          Snack.show(
                                              "Please agree to the terms and conditions",
                                              context);
                                        } else if (email.isNotEmpty &&
                                            password.isNotEmpty &&
                                            _terms == true) {
                                          context.read<LoginBloc>().add(
                                                EmailPasswordChanged(
                                                  email: email,
                                                  password: password,
                                                ),
                                              );
                                          context
                                              .read<LoginBloc>()
                                              .add(EmailLoginApi());
                                        } else {
                                          Snack.show(
                                              "Please enter valid credentials",
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
                                  fontSize: width * 0.04,
                                ),
                                children: [
                                  const TextSpan(text: "Login with "),
                                  TextSpan(
                                    text: "Phone",
                                    style: TextStyles.bodyStyle.copyWith(
                                      color: ColorsPalette.primaryColor,
                                      fontSize: width * 0.04,
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
                            SizedBox(height: height * 0.02),
                            RichText(
                              text: TextSpan(
                                style: TextStyles.bodyStyle.copyWith(
                                  fontSize: width * 0.032,
                                ),
                                children: [
                                  const TextSpan(
                                      text: "Don't have an account? "),
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
