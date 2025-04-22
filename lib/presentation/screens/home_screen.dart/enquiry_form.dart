import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/Enquiry/enquiry_bloc.dart';
import 'package:my_zero_broker/bloc/Enquiry/enquiry_event.dart';
import 'package:my_zero_broker/bloc/Enquiry/enquiry_state.dart';
import 'package:my_zero_broker/presentation/widgets/ElevatedButton.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

class EnquiryFormDialog {
  static void showEnquiryForm(
      BuildContext context, String subject, String img) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismiss by tapping outside the dialog
      builder: (BuildContext ctx) {
        return BlocProvider(
          create: (_) => EnquiryBloc(),
          child: _EnquiryForm(subject: subject, img: img),
        );
      },
    );
  }
}

class _EnquiryForm extends StatefulWidget {
  final String subject;
  final String img;

  const _EnquiryForm({required this.subject, required this.img});

  @override
  _EnquiryFormState createState() => _EnquiryFormState();
}

class _EnquiryFormState extends State<_EnquiryForm> {
  late EnquiryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<EnquiryBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(SubjectChanged(widget
          .subject)); // Moved bloc.add here to avoid calling it during build
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20), // Custom border radius for dialog
      ),
      elevation: 0,
      backgroundColor:
          Colors.transparent, // Transparent background for the dialog
      child: SingleChildScrollView(
        // Make the content scrollable
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ColorsPalette.secondaryColor,
                borderRadius: BorderRadius.circular(30),
                border: const Border(
                  top: BorderSide(
                    color: Colors.white,
                    width: 10.0,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Subject Section
                  Text(
                    'Enquiry Form',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ColorsPalette.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${widget.subject}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorsPalette.primaryColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Text Fields
                  _buildTextField(
                    label: 'Name',
                    onChanged: (value) => _bloc.add(NameChanged(value)),
                  ),
                  _buildTextField(
                    label: 'Email',
                    onChanged: (value) => _bloc.add(EmailChanged(value)),
                  ),
                  _buildTextField(
                    label: 'Phone Number',
                    onChanged: (value) => _bloc.add(PhoneNumberChanged(value)),
                  ),
                  _buildTextField(
                    label: 'Your Query',
                    onChanged: (value) => _bloc.add(QueryChanged(value)),
                  ),
                  SizedBox(height: 20),
                  _buildSubmitButton(_bloc),
                  BlocBuilder<EnquiryBloc, EnquiryState>(
                    builder: (context, state) {
                      if (state.status == EnquiryStatus.loading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state.status == EnquiryStatus.success) {
                        return _buildMessage(state.message, Colors.green);
                      } else if (state.status == EnquiryStatus.error) {
                        return _buildMessage(state.message, Colors.red);
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: -40,
              left: MediaQuery.of(context).size.width / 2 - 80,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blueAccent,
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xFF042b59),
                  child: Image.asset('${widget.img}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
  }) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        style: TextStyle(
          color: ColorsPalette.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: ColorsPalette.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorsPalette.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorsPalette.primaryColor),
          ),
          prefixIcon:
              Icon(Icons.text_fields, color: ColorsPalette.primaryColor),
        ),
        cursorColor: Colors.red,
      ),
    );
  }

  Widget _buildSubmitButton(EnquiryBloc bloc) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Elevatedbutton(
      text: 'Submit',
      height: height * 0.8, // Adjust height to avoid overflow
      width: width * 0.8, // Adjust width to fit in the dialog
      bgcolor: const Color.fromARGB(255, 206, 49, 21),
      foregroundColor: Colors.white,
      onPressed: () {
        bloc.add(SubmitEnquiry());
      },
    );
  }

  Widget _buildMessage(String message, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        message,
        style:
            TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
