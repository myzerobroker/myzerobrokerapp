import 'package:flutter/material.dart';

class SearchForm extends StatefulWidget {
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  // Dropdown values and selections with icons
  final List<Map<String, dynamic>> _locations = [
    {'label': 'Ahmednagar', 'icon': Icons.location_city},
    {'label': 'Pune', 'icon': Icons.location_city},
    {'label': 'Mumbai', 'icon': Icons.location_city},
    {'label': 'Nagpur', 'icon': Icons.location_city},
  ];

  final List<Map<String, dynamic>> _areas = [
    {'label': 'Area 1', 'icon': Icons.map},
    {'label': 'Area 2', 'icon': Icons.map},
    {'label': 'Area 3', 'icon': Icons.map},
  ];

  final List<Map<String, dynamic>> _bhkTypes = [
    {'label': '1 BHK', 'icon': Icons.king_bed},
    {'label': '2 BHK', 'icon': Icons.king_bed},
    {'label': '3 BHK', 'icon': Icons.king_bed},
    {'label': '4 BHK', 'icon': Icons.king_bed},
  ];

  final List<Map<String, dynamic>> _propertyStatus = [
    {'label': 'Available', 'icon': Icons.check_circle},
    {'label': 'Sold Out', 'icon': Icons.cancel},
    {'label': 'Under Construction', 'icon': Icons.construction},
  ];

  final List<Map<String, dynamic>> _propertyTypes = [
    {'label': 'Apartment', 'icon': Icons.apartment},
    {'label': 'Villa', 'icon': Icons.home},
    {'label': 'Plot', 'icon': Icons.landscape},
  ];

  final List<Map<String, dynamic>> _priceRanges = [
    {'label': 'Below ₹10 Lakh', 'icon': Icons.money},
    {'label': '₹10-50 Lakh', 'icon': Icons.money},
    {'label': 'Above ₹50 Lakh', 'icon': Icons.money},
  ];

  // Selected values
  String? _selectedLocation;
  String? _selectedArea;
  String? _selectedBHK;
  String? _selectedStatus;
  String? _selectedType;
  String? _selectedPriceRange;
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCategoryButtons(),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(),
            child: Column(
              children: [
                _buildDropdownWithIcons(
                    'Search Location', _locations, _selectedLocation,
                    (String? newValue) {
                  setState(() => _selectedLocation = newValue);
                }),
                _buildDropdownWithIcons('Search Area', _areas, _selectedArea,
                    (String? newValue) {
                  setState(() => _selectedArea = newValue);
                }),
                _buildDropdownWithIcons('BHK Type', _bhkTypes, _selectedBHK,
                    (String? newValue) {
                  setState(() => _selectedBHK = newValue);
                }),
              ],
            ),
          ),
          _buildDropdownWithIcons(
              'Property Status', _propertyStatus, _selectedStatus,
              (String? newValue) {
            setState(() => _selectedStatus = newValue);
          }),
          _buildDropdownWithIcons(
              'Property Type', _propertyTypes, _selectedType,
              (String? newValue) {
            setState(() => _selectedType = newValue);
          }),
          _buildDropdownWithIcons(
              'Price Range', _priceRanges, _selectedPriceRange,
              (String? newValue) {
            setState(() => _selectedPriceRange = newValue);
          }),
          SizedBox(height: 20),
          _buildSearchButton(),
          SizedBox(height: 10),
          _buildCustomButton(
              Icons.person, "Builder's Plans", Colors.blue, () {}),
          SizedBox(height: 10),
          _buildCustomButton(
              Icons.person, "Post your Property", Colors.red, () {}),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          _buildCategoryButton('Buy', isSelected: index == 0, onTap: () {
            setState(() {
              index = 0;
            });
          }),
          _buildCategoryButton('Rent', isSelected: index == 1, onTap: () {
            setState(() {
              index = 1;
            });
          }),
          _buildCategoryButton('Commercial', isSelected: index == 2, onTap: () {
            setState(() {
              index = 2;
            });
          }),
          _buildCategoryButton('Open Plot / Farmland', isSelected: index == 3,
              onTap: () {
            setState(() {
              index = 3;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label,
      {bool isSelected = false, required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(200, 50),
          foregroundColor: isSelected ? Colors.white : Colors.black,
          backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildDropdownWithIcons(String label, List<Map<String, dynamic>> items,
      String? selectedItem, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
          value: selectedItem,
          icon: Icon(Icons.arrow_drop_down_sharp, color: Colors.grey),
          hint: Text(label),
          onChanged: onChanged,
          items:
              items.map<DropdownMenuItem<String>>((Map<String, dynamic> item) {
            return DropdownMenuItem<String>(
              value: item['label'],
              child: Row(
                children: [
                  Icon(item['icon'], color: Colors.red, size: 20),
                  SizedBox(width: 10),
                  Text(item['label']),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Handle search logic
      },
      icon: Icon(Icons.search, color: Colors.white),
      label: Text(
        'Search',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(350, 60),
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCustomButton(
      IconData icon, String text, Color color, Function f) {
    {
      return ElevatedButton.icon(
        onPressed: () {
          // Handle search logic
          f;
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(350, 60),
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _performSearch() {
    // Perform search logic
    print('Selected Location: $_selectedLocation');
    print('Selected Area: $_selectedArea');
    print('Selected BHK: $_selectedBHK');
    print('Selected Status: $_selectedStatus');
    print('Selected Type: $_selectedType');
    print('Selected Price Range: $_selectedPriceRange');
  }
}
