import 'package:flutter/material.dart';
import 'package:my_zero_broker/utils/constant/payments_colors.dart';

class SellersPlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    

    return Scaffold(
      appBar: AppBar(title: const Text('Sellers Plan')),
      body: SingleChildScrollView(
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
                        'SELLERS PLAN',
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
                2: FlexColumnWidth(1),
              },
              children: [
                _buildTableRow('PLANS', 'FREE', 'PREPAID', 'POSTPAID', screenWidth),
                _buildTableRow('VALIDITY', 'Website Only', '6 Month', '12 Month', screenWidth),
                _buildTableRow('REGISTRATION CHARGES', '₹1000/-', '₹1000 + GST', '₹1000 + GST', screenWidth),
                _buildTableRow('POSTPAID CHARGES', '₹0', '₹1000', '₹1% Brokerage of market value', screenWidth),
                _buildTableRow('Reference number or site visit', '1', '21', 'TILL SALE', screenWidth),
                _buildTableRow('Photo Shoot/ Video Charges', '₹2000', '₹2000', '₹2000', screenWidth),
                _buildIconRow('100% privacy of your data', true, true, true, screenWidth),
                _buildIconRow('Filtration of property', true, true, true, screenWidth),
                _buildIconRow('New property alert on mobile', true, true, true, screenWidth),
                _buildIconRow('Home loan assistance', false, true, true, screenWidth),
                _buildIconRow('Legal Assistance', false, true, true, screenWidth),
                _buildButtonRow(screenWidth),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String title, String col1, String col2, String col3, double screenWidth) {
    return TableRow(
      decoration: const BoxDecoration(color: PaymentsColors.cellBackground),
      children: [
        _buildTableCell(title, isHeader: true, screenWidth: screenWidth),
        _buildTableCell(col1, screenWidth: screenWidth),
        _buildTableCell(col2, screenWidth: screenWidth),
        _buildTableCell(col3, screenWidth: screenWidth),
      ],
    );
  }

  TableRow _buildIconRow(String title, bool free, bool prepaid, bool postpaid, double screenWidth) {
    return TableRow(
      decoration: const BoxDecoration(color: PaymentsColors.cellBackground),
      children: [
        _buildTableCell(title, screenWidth: screenWidth),
        _buildIconCell(free),
        _buildIconCell(prepaid),
        _buildIconCell(postpaid),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = true, required double screenWidth}) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: PaymentsColors.text,
          fontSize: screenWidth > 600 ? 16 : 12, // Adjust font size based on screen width
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
        color: isSuccess ? PaymentsColors.successIcon : PaymentsColors.errorIcon,
      ),
    );
  }

  TableRow _buildButtonRow(double screenWidth) {
    return TableRow(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Select Plans',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _buildButton(screenWidth, 0),
        _buildButton(screenWidth, 1),
        _buildButton(screenWidth, 2),
      ],
    );
  }

 Widget _buildButton(double screenWidth, int index) {
  return Padding(
    padding: EdgeInsets.all(screenWidth * 0.02),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: PaymentsColors.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),  // Remove border radius to make it rectangular
        ),
      ),
      onPressed: () {
        handleButtonPress(index);
      },
      child: Text(
        'Buy now',
        style: TextStyle(color: PaymentsColors.buttonText,fontSize: 9),
      ),
    ),
  );
}

  void handleButtonPress(int index) {
   
    switch (index) {
      case 0:
        print("Free Plan Selected");
        break;
      case 1:
        print("Prepaid Plan Selected");
        break;
      case 2:
        print("Postpaid Plan Selected");
        break;
      default:
        print("Invalid Selection");
    }
  }
}
