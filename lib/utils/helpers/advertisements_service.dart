import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdvertisementService {
  final String apiUrl = 'https://myzerobroker.com/api/all-advertisements';

  Future<List<String>> fetchAdvertisements() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['advertisements'] is List && data['advertisements'].isNotEmpty) {
          return List<String>.from(data['advertisements']);
        }
      }
    } catch (e) {
      debugPrint('Error fetching advertisements: $e');
    }
    return [];
  }
}
