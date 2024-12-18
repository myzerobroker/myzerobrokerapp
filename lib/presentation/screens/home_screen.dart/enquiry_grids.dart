import 'package:flutter/material.dart';
class EnquiryGrids extends StatefulWidget {
  final Function(String, String) onSubjectSelected; // Update the callback to take both subject and image

  EnquiryGrids({required this.onSubjectSelected});

  @override
  State<EnquiryGrids> createState() => _EnquiryGridsState();
}

class _EnquiryGridsState extends State<EnquiryGrids> {
  // Define the list with service names and corresponding image paths
  final List<Map<String, dynamic>> services = [
    {'name': 'ZERO BROKERAGE', 'image': 'assets/images/zero brokerage.png'},
    {'name': 'FREE LISTING', 'image': 'assets/images/free listing.png'},
    {'name': 'VASTU CONSULTANT', 'image': 'assets/images/Swastik-updated (1).png'},
    {'name': 'MAXIMUM EXPOSURE', 'image': 'assets/images/maximum exposure.png'},
    {'name': 'SITE VISITS', 'image': 'assets/images/site visits.png'},
    {'name': 'DIGITAL MARKETING', 'image': 'assets/images/digital marketing.png'},
    {'name': 'AVOID UNNECESSARY CALLS', 'image': 'assets/images/unnecessary calls.png'},
    {'name': 'EASY BUILDER PLAN', 'image': 'assets/images/easy builder plan.png'},
    {'name': 'EASE OF USE', 'image': 'assets/images/ease of use.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Set 3 items per row
          crossAxisSpacing: width * 0.08, // Dynamic cross spacing
          mainAxisSpacing: height * 0.003, // Dynamic main spacing
          childAspectRatio: width / (height * 0.5), //* Adjust aspect ratio for 3 items
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => widget.onSubjectSelected(
                services[index]['name'], services[index]['image']), // Pass both subject and image
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display the image
                Image.asset(
                  services[index]['image'],
                  height: height * 0.07, // Adjust image height dynamically
                  width: width * 0.15, // Adjust image width dynamically
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 8),
                // Blue button with text
                Container(
                  height: height * 0.049, // Adjust button height dynamically
                  width: width * 0.4, // Adjust button width for consistency
                  decoration: BoxDecoration(
                    color: Colors.blue, // Blue button background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      services[index]['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 8, // Adjust font size for fitting text
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
