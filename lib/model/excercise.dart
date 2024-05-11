import 'package:hive_flutter/hive_flutter.dart';
part 'excercise.g.dart';

@HiveType(typeId: 1)
class Excercise extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List<Equipment> equipments;
  @HiveField(3)
  final List<Muscle> mainMuscles;
  @HiveField(4)
  final List<Muscle> secondaryMuscles;
  @HiveField(5)
  final List<Category> categories;

  Excercise({
    required this.id,
    required this.name,
    required this.equipments,
    required this.mainMuscles,
    required this.secondaryMuscles,
    required this.categories,
  });

  factory Excercise.fromJson(Map<String, dynamic> json) {
    return Excercise(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      equipments: json['equipments'] != null
          ? (json['equipments'] as List)
              .map((e) => Equipment.fromJson(e))
              .toList()
          : [],
      mainMuscles:
          (json['mainMuscles'] as List).map((e) => Muscle.fromJson(e)).toList(),
      secondaryMuscles: (json['secondaryMuscles'] as List)
          .map((e) => Muscle.fromJson(e))
          .toList(),
      categories: (json['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
    );
  }
}

@HiveType(typeId: 2)
class Equipment {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;

  Equipment({required this.id, required this.name});

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
    );
  }
}

@HiveType(typeId: 3)
class Muscle {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;

  Muscle({required this.id, required this.name});

  factory Muscle.fromJson(Map<String, dynamic> json) {
    return Muscle(
      id: json['id'],
      name: json['name'],
    );
  }
}

@HiveType(typeId: 4)
class Category {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
