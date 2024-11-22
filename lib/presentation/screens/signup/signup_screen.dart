import 'package:flutter/material.dart';
import 'package:my_zero_broker/presentation/presentaion.dart';
import 'package:my_zero_broker/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
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
                height: height * 0.06,
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
                        "Register",
                        style: TextStyle(
                          fontSize: width * 0.06, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: height * 0.01), 
                      const Text(
                        "Register here and then Log in to continue.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color.fromARGB(255, 90, 42, 42)),
                      ),
                      SizedBox(height: height * 0.02), 
                      Textfield(
                        
                        controller: fullName,
                        textInputType: TextInputType.text,
                        hintText: "Full Name",
                      ),
                      SizedBox(height: height * 0.02), 
                       Textfield(
                        
                        controller: email,
                        textInputType: TextInputType.emailAddress,
                        hintText: "Email Address",
                      ),
                      SizedBox(height: height * 0.02),
                       Textfield(
                        text: "+91",
                        controller: phone,
                        textInputType: TextInputType.phone,
                        hintText: "Enter Mobile Number",
                      ),
                      SizedBox(height: height * 0.02),
                     
                      SizedBox(height: height * 0.02), 
                      Elevatedbutton(
                        onPressed: () {},
                        text: 'REGISTER',
                        height: height * 0.8,
                        width: width , 
                      ),
                      SizedBox(height: height * 0.02), 
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: "Login",
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontSize: width * 0.04, 
                              ),
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
    );
  }
}
