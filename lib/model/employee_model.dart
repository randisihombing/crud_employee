import 'package:hive/hive.dart';

part 'employee_model.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final DateTime birthDate;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final String nik;

  @HiveField(5)
  final int salary;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  Employee({
    required this.id,
    required this.fullName,
    required this.birthDate,
    required this.address,
    required this.nik,
    required this.salary,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'birthDate': birthDate.toIso8601String(),
      'address': address,
      'nik': nik,
      'salary': salary,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

}

