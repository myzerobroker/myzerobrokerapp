import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
part 'buyer_plan_event.dart';
part 'buyer_plan_state.dart';

class BuyerPlanBloc extends Bloc<BuyerPlanEvent, BuyerPlanState> {
  BuyerPlanBloc() : super(BuyerPlanInitial()) {
    on<FetchBuyerPlans>((event, emit) async {
      String url = "https://myzerobroker.com/api/buy-plan";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("authToken");
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Map<String, String> payload = {
        "plan_type": event.planType,
        "plan": event.plan,
      };
      if (token == null) {
        emit(BuyerPlanError(message: "User not authenticated"));
        return;
      }
      try {
        print("Payload: $payload");
        print("URL: $url");

        emit(BuyerPlanLoading());
        final response = await http.post(Uri.parse(url),
            headers: headers, body: jsonEncode(payload));
        print(response.body);

        if (response.statusCode == 200) {
          final json = response.body;
          emit(BuyerPlanSuccess(message: "Our Team will contact you soon"));
        } else {
          emit(BuyerPlanError(message: "Failed to load plans"));
        }
      } catch (err) {
        print(err);
        emit(BuyerPlanError(message: err.toString()));
      }
    });
  }
}
