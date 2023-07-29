import 'dart:convert';

LoginResponseModel loginResponseModel(String str) =>
    LoginResponseModel.fromJson(jsonDecode(str));

class LoginResponseModel {
  int id;
  String phone;
  String text;
  String jwtToken;
  DateTime createdAt;

  LoginResponseModel({
    required this.id,
    required this.phone,
    required this.text,
    required this.jwtToken,
    DateTime? createdAt, // Updated property
  }) : createdAt = createdAt ??
            DateTime.now(); // Set default value to current datetime

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['id'],
      phone: json['phone'],
      text: json['access_level'],
      jwtToken: json['jwtToken'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'text': text,
      'jwtToken': jwtToken,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
