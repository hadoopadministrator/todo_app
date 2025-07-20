// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ToDoModel {
  int? id;
  bool isChecked;
  String title;
  String description;
  final DateTime createdDate;
  DateTime? updatedDate;
  Color? todoItemColor;

  ToDoModel({
    this.id,
    this.isChecked = false,
    required this.title,
    required this.description,
    required this.createdDate,
    this.updatedDate,
    this.todoItemColor,
  });

  // Convert to JSON (for SharedPreferences or APIs)
  Map<String, dynamic> toJson() => {
    'id': id,
    'isChecked': isChecked,
    'title': title,
    'description': description,
    'createdDate': createdDate.toIso8601String(),
    'updatedDate': updatedDate?.toIso8601String(),
    'todoItemColor': todoItemColor?.value,
  };

  // Create from JSON
  factory ToDoModel.fromJson(Map<String, dynamic> json) => ToDoModel(
    id: json['id'],
    isChecked: json['isChecked'] == true || json['isChecked'] == 1,
    title: json['title'],
    description: json['description'],
    createdDate: DateTime.parse(json['createdDate']),
    updatedDate: json['updatedDate'] != null
        ? DateTime.parse(json['updatedDate'])
        : null,
    todoItemColor: json['todoItemColor'] != null
        ? Color(json['todoItemColor'])
        : null,
  );

  //  For SQLite
  Map<String, dynamic> toMap() => {
    'id': id,
    'isChecked': isChecked ? 1 : 0,
    'title': title,
    'description': description,
    'createdDate': createdDate.toIso8601String(),
    'updatedDate': updatedDate?.toIso8601String(),
    'todoItemColor': todoItemColor?.value,
  };

  //  For SQLite
  factory ToDoModel.fromMap(Map<String, dynamic> map) => ToDoModel(
    id: map['id'],
    isChecked: map['isChecked'] == 1,
    title: map['title'],
    description: map['description'],
    createdDate: DateTime.parse(map['createdDate']),
    updatedDate: map['updatedDate'] != null
        ? DateTime.parse(map['updatedDate'])
        : null,
    todoItemColor: map['todoItemColor'] != null
        ? Color(map['todoItemColor'])
        : null,
  );
}
