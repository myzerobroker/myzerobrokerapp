import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_zero_broker/bloc/search_property/search_property_bloc.dart';
import 'package:my_zero_broker/config/routes/routes_name.dart';
import 'package:my_zero_broker/data/area_details_dependency.dart';
import 'package:my_zero_broker/data/user_details_dependency.dart';
import 'package:my_zero_broker/locator.dart';
import 'package:my_zero_broker/presentation/screens/post_farmland/post_farmland.dart';
import 'package:my_zero_broker/presentation/screens/view_property_in_city_page/view_properties.dart';
import 'package:my_zero_broker/presentation/widgets/custom_snack_bar.dart';
import 'package:my_zero_broker/utils/constant/colors.dart';

class SearchForm extends StatefulWidget {
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  // Dropdown values and selections with icons
  final locations = locator.get<AreaDetailsDependency>().cityDetails.map((e) {
    return {
      "label": e.cName,
      "icon": Icons.location_city,
      "id": e.id.toString()
    };
  }).toList();

  final List<Map<String, dynamic>> _bhkTypes = [
    {'label': '1 RK', 'icon': Icons.king_bed},
    {'label': '1 BHK', 'icon': Icons.king_bed},
    {'label': '2 BHK', 'icon': Icons.king_bed},
    {'label': '3 BHK', 'icon': Icons.king_bed},
    {'label': '4 or more BHK', 'icon': Icons.king_bed},
  ];

  final List<Map<String, dynamic>> _propertyStatus = [
    {'label': 'Ready Possession', 'icon': Icons.home},
    {'label': 'Under Construction', 'icon': Icons.construction},
  ];

  final List<Map<String, dynamic>> _propertyTypes = [
    {'label': 'Row House', 'icon': Icons.apartment},
    {'label': 'Flat', 'icon': Icons.apartment},
    {'label': 'Farm House', 'icon': Icons.apartment},
    {'label': 'Individual Villa/Bunglow', 'icon': Icons.home},
    {'label': 'Twin Bunglow', 'icon': Icons.landscape},
  ];

  final List<Map<String, dynamic>> _priceRanges = [
    {'label': '₹10 Lakh - ₹20 Lakh', 'icon': Icons.money},
    {'label': '₹20 Lakh - ₹30 Lakh', 'icon': Icons.money},
    {'label': '₹30 Lakh - ₹50 Lakh', 'icon': Icons.money},
    {'label': '₹50 Lakh - ₹1 Cr', 'icon': Icons.money},
    {'label': 'Above ₹1 Cr', 'icon': Icons.money},
  ];

  final List<Map<String, dynamic>> _movingdate = [
    {'label': 'Immediately', 'icon': Icons.date_range},
    {'label': 'Within 15 Days', 'icon': Icons.date_range},
    {'label': 'After 15 Days', 'icon': Icons.date_range}, // Fixed icon
  ];

  final List<Map<String, dynamic>> _priceRangesforRent = [
    {'label': '₹1000 - ₹5000', 'icon': Icons.money},
    {'label': '₹5000 - ₹10000', 'icon': Icons.money},
    {'label': '₹10000 - ₹25000', 'icon': Icons.money},
    {'label': '₹50000 - ₹1 Lakh', 'icon': Icons.money},
  ];

  final List<Map<String, dynamic>> _propertyTypesForCommercial = [
    {'label': 'Office', 'icon': Icons.local_post_office},
    {'label': 'Store Room', 'icon': Icons.store},
    {'label': 'Shop', 'icon': Icons.shop},
    {'label': 'Show Room', 'icon': Icons.shop},
    {'label': 'Industrial Building', 'icon': Icons.shopify_sharp},
  ];

  final List<Map<String, dynamic>> _propertyBuyorRent = [
    {'label': 'Buy', 'icon': Icons.shopping_bag_sharp},
    {'label': 'Rent', 'icon': Icons.shop},
  ];

  final List<Map<String, dynamic>> _plotArea = [
    {'label': '1 Guntha to 2 Guntha', 'icon': Icons.home},
    {'label': '2 Guntha to 4 Guntha', 'icon': Icons.home},
    {'label': '4 Guntha to 6 Guntha', 'icon': Icons.home},
    {'label': 'More Than 6 Guntha', 'icon': Icons.home},
  ];

  final List<Map<String, dynamic>> _propertyTypesForOpenPlot = [
    {'label': 'Residential Plot', 'icon': Icons.house_siding},
    {'label': 'Commercial Plot', 'icon': Icons.house},
    {'label': 'Amenity', 'icon': Icons.house},
    {'label': 'Farm Land', 'icon': Icons.landscape},
    {'label': 'Industrial Plot', 'icon': Icons.landscape},
  ];

  // Selected values for each dropdown
  String? _selectedLocation = locator
      .get<AreaDetailsDependency>()
      .cityDetails
      .map((e) => {
            "label": e.cName,
            "icon": Icons.location_city,
            "id": e.id.toString()
          })
      .toList()
      .first["label"] as String;
  String? _selectedArea;
  String? _selectedBHK;
  String? _selectedStatus;
  String? _selectedCommStatus; // For Property Status or Moving Date
  String? _selectedBuyOrRent; // For Buy or Rent in Commercial
  String? _selectedType;
  String? _selectedPriceRange;

  final ValueNotifier<int> _indexNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    // Optionally initialize default values here if needed
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCategoryButtons(),
          SizedBox(height: 20),
          ValueListenableBuilder<int>(
            valueListenable: _indexNotifier,
            builder: (context, index, _) {
              switch (index) {
                case 0:
                  return _buyfields();
                case 1:
                  return _rentfields();
                case 2:
                  return _commercialfields();
                case 3:
                  return _openplotfields();
                default:
                  return _buyfields();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buyfields() {
    return BlocListener<SearchPropertyBloc, SearchPropertyState>(
      listener: (context, state) {
        if (state is SearchPropertyError) {
          Snack.show(state.message, context);
        } else if (state is SearchPropertyLoaded) {
          // Handle success if needed
        }
      },
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                _buildDropdownWithIcons(
                    'Search Location', locations, _selectedLocation,
                    (String? newValue) {
                  setState(() => _selectedLocation = newValue);
                }),
                _buildDropdownWithIcons(
                  'Search Area',
                  _selectedLocation == null
                      ? []
                      : (locator
                                  .get<AreaDetailsDependency>()
                                  .areas[_selectedLocation!]
                              as List<Map<String, dynamic>>)
                          .map((e) => {
                                "label": e["a_name"].toString(),
                                "icon": Icons.map
                              })
                          .toList(),
                  _selectedArea,
                  (String? newValue) {
                    setState(() => _selectedArea = newValue);
                  },
                ),
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
          ElevatedButton.icon(
            onPressed: () => _performSearch(context, "Buy"),
            icon: Icon(Icons.search, color: Colors.white),
            label: Text('Search',
                style: TextStyle(fontSize: 18, color: Colors.white)),
            style: ElevatedButton.styleFrom(
                fixedSize: Size(350, 60),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          SizedBox(height: 10),
          _buildCustomButtons(),
        ],
      ),
    );
  }

  Widget _rentfields() {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              _buildDropdownWithIcons(
                  'Search Location', locations, _selectedLocation,
                  (String? newValue) {
                setState(() => _selectedLocation = newValue);
              }),
              _buildDropdownWithIcons(
                'Search Area',
                _selectedLocation == null
                    ? []
                    : (locator
                                .get<AreaDetailsDependency>()
                                .areas[_selectedLocation!]
                            as List<Map<String, dynamic>>)
                        .map((e) => {
                              "label": e["a_name"].toString(),
                              "icon": Icons.map
                            })
                        .toList(),
                _selectedArea,
                (String? newValue) {
                  setState(() => _selectedArea = newValue);
                },
              ),
              _buildDropdownWithIcons('BHK Type', _bhkTypes, _selectedBHK,
                  (String? newValue) {
                setState(() => _selectedBHK = newValue);
              }),
            ],
          ),
        ),
        _buildDropdownWithIcons('Moving Date', _movingdate, _selectedStatus,
            (String? newValue) {
          setState(() => _selectedStatus = newValue);
        }),
        _buildDropdownWithIcons('Property Type', _propertyTypes, _selectedType,
            (String? newValue) {
          setState(() => _selectedType = newValue);
        }),
        _buildDropdownWithIcons(
            'Price Range', _priceRangesforRent, _selectedPriceRange,
            (String? newValue) {
          setState(() => _selectedPriceRange = newValue);
        }),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _performSearch(context, "Rent"),
          icon: Icon(Icons.search, color: Colors.white),
          label: Text('Search',
              style: TextStyle(fontSize: 18, color: Colors.white)),
          style: ElevatedButton.styleFrom(
              fixedSize: Size(350, 60),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
        ),
        SizedBox(height: 10),
        _buildCustomButtons(),
      ],
    );
  }

  Widget _commercialfields() {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              _buildDropdownWithIcons(
                  'Search Location', locations, _selectedLocation,
                  (String? newValue) {
                setState(() => _selectedLocation = newValue);
              }),
              _buildDropdownWithIcons(
                'Search Area',
                _selectedLocation == null
                    ? []
                    : (locator
                                .get<AreaDetailsDependency>()
                                .areas[_selectedLocation!]
                            as List<Map<String, dynamic>>)
                        .map((e) => {
                              "label": e["a_name"].toString(),
                              "icon": Icons.map
                            })
                        .toList(),
                _selectedArea,
                (String? newValue) {
                  setState(() => _selectedArea = newValue);
                },
              ),
            ],
          ),
        ),
        _buildDropdownWithIcons(
            'Buy or Rent', _propertyBuyorRent, _selectedBuyOrRent,
            (String? newValue) {
          setState(() => _selectedBuyOrRent = newValue);
        }),
        _buildDropdownWithIcons(
            'Property Status', _propertyStatus, _selectedCommStatus,
            (String? newValue) {
          setState(() => _selectedCommStatus = newValue);
        }),
        _buildDropdownWithIcons(
            'Property Type', _propertyTypesForCommercial, _selectedType,
            (String? newValue) {
          setState(() => _selectedType = newValue);
        }),
        _buildDropdownWithIcons(
            'Price Range', _priceRanges, _selectedPriceRange,
            (String? newValue) {
          setState(() => _selectedPriceRange = newValue);
        }),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _performSearch(context, "Commercial"),
          icon: Icon(Icons.search, color: Colors.white),
          label: Text('Search',
              style: TextStyle(fontSize: 18, color: Colors.white)),
          style: ElevatedButton.styleFrom(
              fixedSize: Size(350, 60),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
        ),
        SizedBox(height: 10),
        _buildCustomButtons(),
      ],
    );
  }

  Widget _openplotfields() {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              _buildDropdownWithIcons(
                  'Search Location', locations, _selectedLocation,
                  (String? newValue) {
                setState(() => _selectedLocation = newValue);
              }),
              _buildDropdownWithIcons(
                'Search Area',
                _selectedLocation == null
                    ? []
                    : (locator
                                .get<AreaDetailsDependency>()
                                .areas[_selectedLocation!]
                            as List<Map<String, dynamic>>)
                        .map((e) => {
                              "label": e["a_name"].toString(),
                              "icon": Icons.map
                            })
                        .toList(),
                _selectedArea,
                (String? newValue) {
                  setState(() => _selectedArea = newValue);
                },
              ),
              _buildDropdownWithIcons('Plot Area', _plotArea, _selectedBHK,
                  (String? newValue) {
                setState(() => _selectedBHK = newValue);
              }),
            ],
          ),
        ),
        _buildDropdownWithIcons(
            'Property Type', _propertyTypesForOpenPlot, _selectedType,
            (String? newValue) {
          setState(() => _selectedType = newValue);
        }),
        _buildDropdownWithIcons(
            'Price Range', _priceRanges, _selectedPriceRange,
            (String? newValue) {
          setState(() => _selectedPriceRange = newValue);
        }),
        SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _performSearch(context, "Plot_farmland"),
          icon: Icon(Icons.search, color: Colors.white),
          label: Text('Search',
              style: TextStyle(fontSize: 18, color: Colors.white)),
          style: ElevatedButton.styleFrom(
              fixedSize: Size(350, 60),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
        ),
        SizedBox(height: 10),
        _buildCustomButtons(),
      ],
    );
  }

  Widget _buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.count(
        crossAxisCount: 4, // 4 elements per row
        shrinkWrap: true, // Prevents GridView from taking infinite height
        physics: NeverScrollableScrollPhysics(), // Disables scrolling
        // mainAxisSpacing: 10, // Space between rows
        crossAxisSpacing: 10, // Space between columns
        children: [
          _buildCategoryButton('Buy', 0, Iconsax.safe_home4),
          _buildCategoryButton('Rent', 1, Iconsax.house4),
          _buildCategoryButton('Commercial', 2, Iconsax.building4),
          _buildCategoryButton('Open Plot / Farmland', 3, Iconsax.tree4),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String label, int value, IconData icon) {
    return ValueListenableBuilder<int>(
      valueListenable: _indexNotifier,
      builder: (context, index, _) {
        return GestureDetector(
          onTap: () {
            _indexNotifier.value = value;
          },
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: index == value
                      ? ColorsPalette.primaryColor
                      : ColorsPalette.secondaryColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: index == value ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorsPalette.primaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdownWithIcons(String label, List<Map<String, dynamic>> items,
      String? selectedItem, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsPalette.secondaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorsPalette.primaryColor, width: 1),
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
                  Icon(item['icon'],
                      color: ColorsPalette.primaryColor, size: 20),
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

  Widget _buildCustomButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () =>
              Navigator.pushNamed(context, RoutesName.postbuilderform),
          icon: Icon(Icons.money, color: Colors.white),
          label: Text("Builder's Plan",
              style: TextStyle(fontSize: 18, color: Colors.white)),
          style: ElevatedButton.styleFrom(
              fixedSize: Size(350, 60),
              backgroundColor: ColorsPalette.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => locator.get<UserDetailsDependency>().id != -1
              ? Navigator.pushNamed(context, RoutesName.postpropertyScreen)
              : Navigator.pushNamed(context, RoutesName.loginScreen),
          icon: Icon(Icons.home, color: Colors.white),
          label: Text('Post Property for Free',
              style: TextStyle(fontSize: 18, color: Colors.white)),
          style: ElevatedButton.styleFrom(
              fixedSize: Size(350, 60),
              backgroundColor: ColorsPalette.primaryColor.withOpacity(1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            final areas = locator
                .get<AreaDetailsDependency>()
                .areas[_selectedLocation!] as List<Map<String, dynamic>>;
            print(areas);

            locator.get<UserDetailsDependency>().id != -1
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostFarmland(
                              areas: areas,
                            )))
                : Navigator.pushNamed(context, RoutesName.loginScreen);
          },
          icon: Icon(Icons.add_location_alt_rounded, color: Colors.white),
          label: Text('Post your Plot',
              style: TextStyle(fontSize: 18, color: Colors.white)),
          style: ElevatedButton.styleFrom(
              fixedSize: Size(350, 60),
              backgroundColor: ColorsPalette.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  void _performSearch(BuildContext context, String status) {
    if (_selectedLocation == null) {
      Snack.show("Please select a Location", context);
    } else {
      print("Selected Location: $_selectedLocation");
      final id = locations
          .firstWhere((element) => element["label"] == _selectedLocation)["id"];
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        final area = _selectedArea == null
            ? ""
            : (locator.get<AreaDetailsDependency>().areas[_selectedLocation!]
                    as List<Map<String, dynamic>>)
                .firstWhere(
                    (element) => element["a_name"] == _selectedArea)["id"];
        print("Area ID: $area");

        return ViewProperties(
          tp: status,
          city_id: id.toString(),
          status: status == "Commercial" ? _selectedBuyOrRent ?? "Buy" : status,
          bhk: _selectedBHK == null
              ? ""
              : _selectedBHK! == "4 or more BHK"
                  ? "4BHK"
                  : _selectedBHK!.split(" ").join(""),
          area: area.toString(),
          propertyType: _selectedType ?? "",
          priceRange: _selectedPriceRange ?? "",
        );
      }));
    }
  }
}
