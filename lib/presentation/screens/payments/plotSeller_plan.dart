import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_zero_broker/bloc/buyer/buyer_plan_bloc.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/utils/constant/payments_colors.dart';

class PlotSellerPlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Plot Sellers Plan')),
      body: BlocListener<BuyerPlanBloc, BuyerPlanState>(
         listener: (context, state) {
          if (state is BuyerPlanSuccess) {
            Snack.show(state.message, context);
          } else if (state is BuyerPlanError) {
            Snack.show(state.message, context);
          
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: PaymentsColors.headerBackground,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        alignment: Alignment.center,
                        child: const Text(
                          'PLOT SELLERS PLAN',
                          style: TextStyle(
                            color: PaymentsColors.headerText,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: PaymentsColors.freePlan,
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        alignment: Alignment.center,
                        child: const Text(
                          'GET STARTED',
                          style: TextStyle(
                            color: PaymentsColors.headerText,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: PaymentsColors.premiumPlan,
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        alignment: Alignment.center,
                        child: const Text(
                          'PREMIUM PLANS',
                          style: TextStyle(
                            color: PaymentsColors.headerText,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Table
              Table(
                border: TableBorder.all(color: Colors.blue, width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: [
                  _buildTableRow('PLANS', 'FREE', 'POSTPAID', screenWidth),
                  _buildTableRow(
                      'VALIDITY', 'Website Only', '12 Month', screenWidth),
                  _buildTableRow('REGISTRATION CHARGES', '₹500/-',
                      '₹1000 + GST', screenWidth),
                  _buildTableRow('POSTPAID CHARGES', '₹500',
                      '₹1% brokerage of market value', screenWidth),
                  _buildTableRow('Reference number or site visit', '1',
                      'TILL SALE OF THE PLOT', screenWidth),
                  _buildIconRow(
                      '100% privacy of your data', true, true, screenWidth),
                  _buildIconRow(
                      'Filtration of property', true, true, screenWidth),
                  _buildIconRow(
                      'New property alert on mobile', true, true, screenWidth),
                  _buildIconRow(
                      'Home loan assistance', true, true, screenWidth),
                  _buildIconRow('Legal Assistance', false, true, screenWidth),
                  _buildButtonRow(screenWidth, context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(
      String title, String col1, String col3, double screenWidth) {
    return TableRow(
      decoration: const BoxDecoration(color: PaymentsColors.cellBackground),
      children: [
        _buildTableCell(title, isHeader: true, screenWidth: screenWidth),
        _buildTableCell(col1, screenWidth: screenWidth),
        _buildTableCell(col3, screenWidth: screenWidth),
      ],
    );
  }

  TableRow _buildIconRow(
      String title, bool free, bool postpaid, double screenWidth) {
    return TableRow(
      decoration: const BoxDecoration(color: PaymentsColors.cellBackground),
      children: [
        _buildTableCell(title, screenWidth: screenWidth),
        _buildIconCell(free),
        _buildIconCell(postpaid),
      ],
    );
  }

  Widget _buildTableCell(String text,
      {bool isHeader = true, required double screenWidth}) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: PaymentsColors.text,
          fontSize: screenWidth > 600
              ? 16
              : 12.35, // Adjust font size based on screen width
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildIconCell(bool isSuccess) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        isSuccess ? Icons.check_circle : Icons.cancel,
        color:
            isSuccess ? PaymentsColors.successIcon : PaymentsColors.errorIcon,
      ),
    );
  }

  TableRow _buildButtonRow(double screenWidth, context) {
    return TableRow(
      children: [
        const Padding(
          padding: EdgeInsets.all(19.0),
          child: Text(
            'Select Plans',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _buildButton(screenWidth, 0, context),
        _buildButton(screenWidth, 1, context),
      ],
    );
  }

  Widget _buildButton(double screenWidth, int index, context) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PaymentsColors.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                9), // Remove border radius to make it rectangular
          ),
        ),
        onPressed: () {
          handleButtonPress(index, context);
        },
        child: Text(
          'Buy now',
          style: TextStyle(color: PaymentsColors.buttonText, fontSize: 9),
        ),
      ),
    );
  }

  void handleButtonPress(int index, context) {
    String planType;

    switch (index) {
      case 0:
        planType = "Free";
        break;
      case 1:
        planType = "Prepaid";
        break;
      case 2:
        planType = "Postpaid";
        break;
      default:
        planType = "Unknown";
    }
    print("Selected Plan Type: $planType");
    BlocProvider.of<BuyerPlanBloc>(context)
        .add(FetchBuyerPlans(planType, "Plot Sellers"));
  }
}
