import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/contact/contact_bloc.dart';
import 'package:my_zero_broker/bloc/contact/contact_event.dart';
import 'package:my_zero_broker/bloc/contact/contact_state.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => ContactBloc(),
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
          child: BlocListener<ContactBloc, ContactState>(
            listener: (context, state) {
              if (state.status == ContactStatus.success) {
                Snack.show(state.message ?? "Message sent successfully!", context);
                emailController.clear();
                nameController.clear();
                messageController.clear();
              } else if (state.status == ContactStatus.failure) {
                Snack.show(state.message ?? "Failed to send the message.", context);
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
                    SizedBox(height: height * 0.05),
                    Card(
                      color: ColorsPalette.cardBgColor.withOpacity(0.95),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: height * 0.02),
                            Text(
                              "Contact Us",
                              textAlign: TextAlign.center,
                              style: TextStyles.headingStyle.copyWith(
                                fontSize: width * 0.05,
                              ),
                            ),
                            SizedBox(height: height * 0.0),
                             Text(
                              "Get in touch with us!",
                              textAlign: TextAlign.center,
                              style: TextStyles.bodyStyle.copyWith(
                                color: ColorsPalette.textSecondaryColor,
                                fontSize: width * 0.035,
                              ),
                            ),
                              SizedBox(height: height * 0.01),
                            Row(
                              children: const [
                                Icon(Icons.phone, color: ColorsPalette.primaryColor),
                                SizedBox(width: 10),
                                Text(
                                  "Phone: +91 7031005005",
                                  style: TextStyles.bodyStyle,
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: const [
                                Icon(Icons.email, color: ColorsPalette.primaryColor),
                                SizedBox(width: 10),
                                Text(
                                  "Email: hi@myzerobroker.com",
                                  style: TextStyles.bodyStyle,
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                           
                            SizedBox(height: height * 0.0),
                          
                            const SizedBox(height: 20),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: height * 0.02),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: "Full Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              keyboardType: TextInputType.name,
                            ),
                            SizedBox(height: height * 0.02),
                            TextField(
                              controller: messageController,
                              maxLines: 6,
                              decoration: InputDecoration(
                                hintText: "Message",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              keyboardType: TextInputType.multiline,
                            ),
                            SizedBox(height: height * 0.02),
                            
                            BlocBuilder<ContactBloc, ContactState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorsPalette.primaryColor,
                                    foregroundColor: ColorsPalette.bgColor,
                                    minimumSize: Size.fromHeight(height * 0.06),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: state.status == ContactStatus.sending
                                      ? null
                                      : () {
                                          final name = nameController.text.trim();
                                          final email = emailController.text.trim();
                                          final message = messageController.text.trim();

                                          if (name.isEmpty || email.isEmpty || message.isEmpty) {
                                            Snack.show(
                                                "Please fill all fields before submitting.", context);
                                            return;
                                          }

                                          context.read<ContactBloc>().add(
                                                SendContactMessage(
                                                  name: name,
                                                  email: email,
                                                  message: message,
                                                ),
                                              );
                                        },
                                  child: state.status == ContactStatus.sending
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          "Send Message",
                                         
                                        ),
                                );
                              },
                            ),
                            SizedBox(height: height * 0.02),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Column(
                      children: [
                       
                     
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