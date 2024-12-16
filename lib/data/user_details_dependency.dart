import 'dart:convert';

import 'package:my_zero_broker/data/models/user_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsDependency {
  UserDetails? userModel;
  int id = -1;

  Future<int> fetchUserId() async {
    final sp = await SharedPreferences.getInstance();
    return id = sp.getInt("userId") ?? -1;
  }

  Future<UserDetails?> fetchUserDetails() async {
    final id = await fetchUserId();
    try {
      if (id == -1) {
        print("userId not saved ");
        return null;
      }
      final response = await http.get(
        Uri.parse('https://myzerobroker.com/api/user/$id'),
      );
      print(response.body);
      if (response.statusCode == 200) {
        // final json = jsonDecode(response.body);
        // print(json.runtimeType); 
        userModel = userDetailsFromJson(response.body);
        return userModel;
      } else {
        return null;
      }
    } catch (err) {
      print(err);
      return null;
    }
  }
}
