import 'package:get/get.dart';

class ElectronicTasbihModel {
  int? id;
  String name;
  String advantage;
  int count;
  int isSystem;

  RxInt counter = RxInt(0);
  RxInt totalCounter = RxInt(0);

  // Constructor
  ElectronicTasbihModel({
    this.id,
    required this.name,
    required this.count,
    required this.advantage,
    required this.isSystem,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'conut': count, 'counter': counter.value, 'total_counter': totalCounter.value, 'advantage': advantage, 'is_system': isSystem};
  }

  // Create object from JSON
  factory ElectronicTasbihModel.fromJson(Map<String, dynamic> json) {
    return ElectronicTasbihModel(
      id: json['id'],
      name: json['name'],
      count: json['conut'],
      advantage: json['advantage'],
      isSystem: json['is_system'],
    )
      ..counter.value = json['counter'] ?? 0
      ..totalCounter.value = json['total_counter'] ?? 0;
  }
}
