import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/invoice/invoice_bloc.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/presentation/widgets/pdf_viewer_page.dart';
import 'package:my_zero_broker/utils/constant/theme.dart';

import '../../locator.dart';
// import 'package:my_zero_broker/blocs/invoice_bloc.dart';

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvoiceBloc()..add(FetchInvoices()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Invoices')),
        body: BlocBuilder<InvoiceBloc, InvoiceState>(
          builder: (context, state) {
            print('Current state: $state');
            if (state is InvoiceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InvoiceLoaded) {
              if (state.invoices.isEmpty) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/box-2071537_1280.png",
                        height: 200, width: 200),
                    const SizedBox(height: 20),
                    Text(
                      'No invoices available',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600),
                    ),
                  ],
                ));
              }
              return ListView.builder(
                itemCount: state.invoices.length,
                itemBuilder: (context, index) {
                  final invoice = state.invoices[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: ColorsPalette.primaryColor,
                        child: Text(
                          invoice.planName.isNotEmpty
                              ? invoice.planName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      tileColor: ColorsPalette.primaryColor.withOpacity(0.1),
                      title: Text(
                        'Plan name: ${invoice.planName} - ${invoice.planType}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorsPalette.primaryColor),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            final user =
                                locator.get<UserDetailsDependency>().userModel;
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => InvoiceViewPage(
                                        recipientName:
                                            user?.user?.name ?? "Not Defined",
                                        invoice: invoice)));
                          },
                          icon: Column(
                            children: [
                              Icon(Icons.download,
                                  color: ColorsPalette.primaryColor),
                              Text("Download",
                                  style: TextStyle(
                                      color: ColorsPalette.primaryColor,
                                      fontSize: 8)),
                            ],
                          )),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Validity: ${invoice.validity}'),
                          Text('Amount: ₹${invoice.price}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is InvoiceError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No invoices available'));
          },
        ),
      ),
    );
  }
}
