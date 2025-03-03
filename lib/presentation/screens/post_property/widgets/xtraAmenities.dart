import 'package:flutter/material.dart';
import 'package:my_zero_broker/presentation/screens/post_property/widgets/checkboxes.dart';

class ExtraAmenitieWidget extends StatefulWidget {
  final Function(List<Map<String, dynamic>>)? onAmenitiesChanged; // Callback to send updated amenities

  const ExtraAmenitieWidget({Key? key, this.onAmenitiesChanged}) : super(key: key);

  @override
  _ExtraAmenitieWidgetState createState() => _ExtraAmenitieWidgetState();
}

class _ExtraAmenitieWidgetState extends State<ExtraAmenitieWidget> {
  final List<Map<String, dynamic>> _amenities = [
    {'label': 'Lift', 'value': false},
    {'label': 'Internet Service', 'value': false},
    {'label': 'Air Conditioner', 'value': false},
    {'label': 'Club House', 'value': false},
    {'label': 'Intercom', 'value': false},
    {'label': 'Swimming Pool', 'value': false},
    {'label': 'Childrens Play Area', 'value': false},
    {'label': 'Fire Safety', 'value': false},
    {'label': 'Servant Room', 'value': false},
    {'label': 'Shopping Center', 'value': false},
    {'label': 'Gas Pipeline', 'value': false},
    {'label': 'Park', 'value': false},
    {'label': 'Rain Water Harvesting', 'value': false},
    {'label': 'Sewage Treatment Plant', 'value': false},
    {'label': 'House Keeping', 'value': false},
    {'label': 'Power Backup', 'value': false},
    {'label': 'Visitor Parking', 'value': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Select the amenities available',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 5,
            runSpacing: 1,
            children: _amenities.map((amenity) {
              return CustomCheckbox(
                label: amenity['label'],
                initialValue: amenity['value'],
                onChanged: (bool? value) {
                  setState(() {
                    amenity['value'] = value ?? false;
                    if (widget.onAmenitiesChanged != null) {
                      widget.onAmenitiesChanged!(_amenities); // Notify parent of changes
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Method to get the current state of amenities
  List<Map<String, dynamic>> getAmenities() => _amenities;
}