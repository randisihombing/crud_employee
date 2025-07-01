import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../model/employee_model.dart';

class EmployeeProvider extends ChangeNotifier {
  final _box = Hive.box<Employee>('employees');

  List<Employee> get employees => _box.values.toList();

  void addEmployee(Employee employee) {
    _box.add(employee);
    notifyListeners();
  }

  void updateEmployee(int index, Employee employee) {
    _box.putAt(index, employee);
    notifyListeners();
  }

  void deleteEmployee(int index) {
    _box.deleteAt(index);
    notifyListeners();
  }

  void clearAll() {
    _box.clear();
    notifyListeners();
  }
}
