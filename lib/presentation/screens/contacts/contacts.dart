import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/contact/contact_bloc.dart';
import 'package:my_zero_broker/bloc/contact/contact_event.dart';
import 'package:my_zero_broker/bloc/contact/contact_state.dart';
import 'package:my_zero_broker/presentation/screens/home_screen.dart/header_widget.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';


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
    return BlocProvider(
      create: (_) => ContactBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Contact Us"),
          backgroundColor: Colors.white,
          elevation: 1,
          foregroundColor: Colors.black,
        ),
        body: BlocListener<ContactBloc, ContactState>(
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
               HeaderWidget(),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Let's Talk About Everything",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(Icons.phone, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            "Phone: +91 7031005005",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: const [
                          Icon(Icons.email, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(
                            "Email: hi@myzerobroker.com",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 20),
                      BlocBuilder<ContactBloc, ContactState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size.fromHeight(50),
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
                                : const Text(
                                    "Send Message",
                                    style: TextStyle(fontSize: 18, color: Colors.white),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
