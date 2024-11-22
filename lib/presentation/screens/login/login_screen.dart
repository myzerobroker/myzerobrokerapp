import 'package:flutter/material.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/presentation/presentaion.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
  
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        
        centerTitle:true ,
        title:  Text.rich(
          TextSpan(
                                children: [
                                  TextSpan(text: "REAL ESTATE, ",
                                  style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.059, 
                                      
                                    ),),
                                  TextSpan(
                                    text: "SIMPLIFIED",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 116, 0, 0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.059, 
                                      
                                    ),
                                  ),
                                ],
                              ),),
        elevation: 0,
        backgroundColor: ColorsPalette.appBarColor,
        
      ),
      body: SingleChildScrollView(
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
                        style: TextStyle(color: Color.fromARGB(255, 90, 42, 42)),
                      ),
                      SizedBox(height: height * 0.02), 
                      Textfield(
                        text: "+91",
                        controller: phoneNo,
                        textInputType: const TextInputType.numberWithOptions(),
                        hintText: "Enter Mobile Number",
                      ),
                      SizedBox(height: height * 0.02), 
                      Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (value) {},
                          ),
                          Flexible(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: "I agree with the "),
                                  TextSpan(
                                    text: "terms and conditions.",
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
                      SizedBox(height: height * 0.02), 
                      Elevatedbutton(
                        onPressed: () {},
                        text: 'SEND OTP',
                        height: height * 0.8,
                        width: width , 
                      ),
                      SizedBox(height: height * 0.02), 
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.signUpScreen);
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
    );
  }
}
