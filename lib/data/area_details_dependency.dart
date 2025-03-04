import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_zero_broker/data/models/city_details_model.dart';

class AreaDetailsDependency {
  List<CityDetails> cityDetails = [];
  Map<String, List<Map<String, dynamic>>> areas = {}; // Explicitly specify the type

  Future<List<CityDetails>> fetchAreas() async {
    final locationUrl = "https://myzerobroker.com/api/city-details";
    final areaUrl = "https://myzerobroker.com/api/areas?cityId=";
    final response = await http.get(
      Uri.parse(locationUrl),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print(data);
      cityDetails = data.map((e) => CityDetails.fromJson(e)).toList();

      for (var i = 0; i < cityDetails.length; i++) {
        final response = await http.get(
          Uri.parse(areaUrl + cityDetails[i].id.toString()),
        );
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          areas[cityDetails[i].cName.toString()] = data.map((e) {
            // Explicitly convert each map to Map<String, dynamic>
            return (e as Map).map((key, value) => MapEntry(key.toString(), value));
          }).toList();
        } else {
          throw Exception('Failed to load areas');
        }
      }
      print(areas);
      return cityDetails;
    } else {
      throw Exception('Failed to load areas');
    }
  }
}