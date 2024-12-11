// To parse this JSON data, do
//
//     final cityDetails = cityDetailsFromJson(jsonString);

import 'dart:convert';

List<CityDetails> cityDetailsFromJson(String str) => List<CityDetails>.from(json.decode(str).map((x) => CityDetails.fromJson(x)));

String cityDetailsToJson(List<CityDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityDetails {
    int id;
    String cName;
    int deleteStatus;
    DateTime createdAt;
    DateTime updatedAt;

    CityDetails({
        required this.id,
        required this.cName,
        required this.deleteStatus,
        required this.createdAt,
        required this.updatedAt,
    });

    factory CityDetails.fromJson(Map<String, dynamic> json) => CityDetails(
        id: json["id"],
        cName: json["c_name"],
        deleteStatus: json["delete_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "c_name": cName,
        "delete_status": deleteStatus,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
