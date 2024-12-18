import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/Enquiry/enquiry_bloc.dart';
import 'package:my_zero_broker/bloc/Enquiry/enquiry_event.dart';
import 'package:my_zero_broker/bloc/Enquiry/enquiry_state.dart';

class EnquiryFormModal {
  static void showEnquiryForm(BuildContext context, String subject) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return BlocProvider(
          create: (_) => EnquiryBloc(),
          child: _EnquiryForm(subject: subject),
        );
      },
    );
  }
}

class _EnquiryForm extends StatelessWidget {
  final String subject;

  const _EnquiryForm({required this.subject});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EnquiryBloc>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subject: $subject',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextField(
            onChanged: (value) => bloc.add(NameChanged(value)),
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            onChanged: (value) => bloc.add(EmailChanged(value)),
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            onChanged: (value) => bloc.add(PhoneNumberChanged(value)),
            decoration: InputDecoration(labelText: 'Phone Number'),
          ),
          TextField(
            onChanged: (value) => bloc.add(QueryChanged(value)),
            decoration: InputDecoration(labelText: 'Your Query'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              bloc.add(SubmitEnquiry());
            },
            child: Text('Submit'),
          ),
          BlocBuilder<EnquiryBloc, EnquiryState>(
            builder: (context, state) {
              if (state.status == EnquiryStatus.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state.status == EnquiryStatus.success) {
                return Text('Success: ${state.message}');
              } else if (state.status == EnquiryStatus.error) {
                return Text('Error: ${state.message}', style: TextStyle(color: Colors.red));
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
