// To parse this JSON data, do
//
//     final userDetails = userDetailsFromJson(jsonString);

import 'dart:convert';

UserDetails userDetailsFromJson(String str) => UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
    bool? success;
    String? message;
    User? user;

    UserDetails({
        this.success,
        this.message,
        this.user,
    });

    factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        success: json["success"],
        message: json["message"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "user": user?.toJson(),
    };
}

class User {
    int? id;
    String? userType;
    String? name;
    dynamic? city;
    String? email;
    dynamic? emailVerifiedAt;
    String? mobileNo;
    int? deleteStatus;
    DateTime? createdAt;
    DateTime? updatedAt;

    User({
        this.id,
        this.userType,
        this.name,
        this.city,
        this.email,
        this.emailVerifiedAt,
        this.mobileNo,
        this.deleteStatus,
        this.createdAt,
        this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userType: json["user_type"],
        name: json["name"],
        city: json["city"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        mobileNo: json["mobile_no"],
        deleteStatus: json["delete_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_type": userType,
        "name": name,
        "city": city,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "mobile_no": mobileNo,
        "delete_status": deleteStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
