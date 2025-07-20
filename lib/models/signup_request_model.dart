// To parse this JSON data, do
//
//     final signupRequestModel = signupRequestModelFromJson(jsonString);

import 'dart:convert';

SignupRequestModel signupRequestModelFromJson(String str) =>
    SignupRequestModel.fromJson(json.decode(str));

String signupRequestModelToJson(SignupRequestModel data) =>
    json.encode(data.toJson());

class SignupRequestModel {
  final String userid;
  final String password;
  final String name;
  final String email;

  SignupRequestModel({
    required this.userid,
    required this.password,
    required this.name,
    required this.email,
  });

  factory SignupRequestModel.fromJson(Map<String, dynamic> json) =>
      SignupRequestModel(
        userid: json["userid"],
        password: json["password"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "password": password,
    "name": name,
    "email": email,
  };
}
