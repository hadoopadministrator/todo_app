// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  final bool? isValid;
  final String? message;
  final User? user;

  LoginResponseModel({this.isValid, this.message, this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        isValid: json["isValid"],
        message: json["message"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
    "isValid": isValid,
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
