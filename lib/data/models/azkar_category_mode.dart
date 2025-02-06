import 'package:flutter/material.dart';

class AzkarCategoryModel {
  int? id;
  String title; // Assuming name is a String, adjust the type accordingly
  bool isAddedByUser;

  AzkarCategoryModel({
    this.id,
    required this.title,
    required this.isAddedByUser,
  });

  // Convert a JSON object to an AzkarCategoryModel instance
  factory AzkarCategoryModel.fromJson(Map<String, dynamic> json) {
    return AzkarCategoryModel(
      id: json['id'] as int,
      title: toLocalJson(json['title'] as String),
      isAddedByUser: json['isAddedByUser'] == 0 ? false : true,
    );
  }
  static String toLocalJson(String dpName) {
    switch (dpName) {
      case 'أذكار الصباح':
        return 'morningAzkarTitle';
      case 'أذكار المساء':
        return 'eveningAzkarTitle';
      case 'أذكار الصلاة':
        return 'prayerAzkar';
      case "أذكار بعد الصلاة":
        return 'prayerAzkarAfter';
      case 'أذكار النوم':
        return 'sleepAzkarTitle';
      case 'أذكار الآذان':
        return 'adhnAzkar';
      case "أذكار الإستيقاظ":
        return 'wakingupAzker';
      case "أذكار المسجد":
        return 'masjdAzkar';
      case "أذكار الوضوء":
        return 'ablutionAzker';
      case "أذكار المنزل":
        return 'homeAzkar';
      case "أذكار الطعام":
        return 'food Azkar';
      case "أذكار السفر":
        return 'travelAzkar';
      case "أذكار الخلاء":
        return 'emptyِAzkar';
      default:
        return dpName;
    }
  }

  // Convert an AzkarCategoryModel instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isAddedByUser': isAddedByUser,
    };
  }
}
