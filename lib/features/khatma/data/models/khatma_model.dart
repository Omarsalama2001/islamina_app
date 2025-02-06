import 'package:islamina_app/services/services.dart';

class KhatmaModel {
  String id;
  String name;
  String description;
  String khatmaType;
  bool moshafType;
  int expectedPeriodOfKhatma;
  String unit;
  int valueOfUnit;
  int unitPerDay;
  DateTime createdAt;
  DateTime lastModified;
  int initialPage;
  int lastPage;
  bool isTaped;

  KhatmaModel({
    required this.id,
    required this.name,
    required this.description,
    required this.khatmaType,
    required this.moshafType,
    required this.expectedPeriodOfKhatma,
    required this.unit,
    required this.valueOfUnit,
    required this.unitPerDay,
    required this.createdAt,
    required this.lastModified,
    required this.initialPage,
    required this.lastPage,
    required this.isTaped,
  });

  factory KhatmaModel.fromJson(Map<String, dynamic> json) {
    return KhatmaModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      khatmaType: json['khatmaType'],
      moshafType: json['moshafType'],
      expectedPeriodOfKhatma: json['expectedPeriodOfKhatma'],
      unit: json['unit'],
      valueOfUnit: json['valueOfUnit'],
      unitPerDay: json['unitPerDay'],
      createdAt: DateTime.parse(json['createdAt']),
      initialPage: json['initialPage'],
      lastPage: json['lastPage'],
      lastModified: DateTime.parse(json['lastModified']),
      isTaped: json['isTaped'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description, 'khatmaType': khatmaType, 'moshafType': moshafType, 'expectedPeriodOfKhatma': expectedPeriodOfKhatma, 'unit': unit,'valueOfUnit':valueOfUnit ,'unitPerDay': unitPerDay, 'createdAt': createdAt.toIso8601String(), 'initialPage': initialPage, 'lastPage': lastPage, 'lastModified': lastModified.toIso8601String(), 'isTaped': isTaped};
  }
}
