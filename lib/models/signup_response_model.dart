// To parse this JSON data, do
//
//     final signupResponseModel = signupResponseModelFromJson(jsonString);

import 'dart:convert';

SignupResponseModel signupResponseModelFromJson(String str) =>
    SignupResponseModel.fromJson(json.decode(str));

String signupResponseModelToJson(SignupResponseModel data) =>
    json.encode(data.toJson());

class SignupResponseModel {
  final bool? success;
  final String? message;
  final User? user;

  SignupResponseModel({this.success, this.message, this.user});

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) =>
      SignupResponseModel(
        success: json["success"],
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "user": user?.toJson(),
  };
}

class User {
  final String? id;
  final String? userid;
  final String? password;
  final String? name;
  final String? email;
  final bool? isActive;

  User({
    this.id,
    this.userid,
    this.password,
    this.name,
    this.email,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    userid: json["userid"],
    password: json["password"],
    name: json["name"],
    email: json["email"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "password": password,
    "name": name,
    "email": email,
    "isActive": isActive,
  };
}
