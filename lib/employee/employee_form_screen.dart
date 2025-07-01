import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/employee_model.dart';
import '../provider/employee_provider.dart';


class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;
  final int? index;

  const EmployeeFormScreen({this.employee, this.index});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _nikController = TextEditingController();
  final _salaryController = TextEditingController();
  DateTime? _birthDate;

  bool get isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final emp = widget.employee!;
      _fullNameController.text = emp.fullName;
      _birthDate = emp.birthDate;
      _addressController.text = emp.address;
      _nikController.text = emp.nik;
      _salaryController.text = emp.salary.toString();
    }
  }

  String generateEmployeeId(List<Employee> existingEmployees) {
    final now = DateTime.now();
    final yyyymm = DateFormat('yyyyMM').format(now);
    final currentMonthEmployees = existingEmployees
        .where((e) => e.id.startsWith(yyyymm))
        .toList();

    final nextNumber = (currentMonthEmployees.length + 1)
        .toString()
        .padLeft(5, '0');

    return '$yyyymm$nextNumber';
  }

  void _saveEmployee() {
    if (!_formKey.currentState!.validate() || _birthDate == null) return;

    final provider = context.read<EmployeeProvider>();
    final now = DateTime.now();

    final newEmployee = Employee(
      id: isEditing
          ? widget.employee!.id
          : generateEmployeeId(provider.employees),
      fullName: _fullNameController.text.trim(),
      birthDate: _birthDate!,
      address: _addressController.text.trim(),
      nik: _nikController.text.trim(),
      salary: int.parse(_salaryController.text.trim()),
      createdAt: isEditing ? widget.employee!.createdAt : now,
      updatedAt: now,
    );

    if (isEditing && widget.index != null) {
      provider.updateEmployee(widget.index!, newEmployee);
    } else {
      provider.addEmployee(newEmployee);
    }

    Navigator.pop(context);
  }

  void _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM yyyy');
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Employee' : 'Add Employee')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              InkWell(
                onTap: _pickBirthDate,
                child: InputDecorator(
                  decoration: InputDecoration(labelText: 'Birthdate'),
                  child: Text(
                    _birthDate != null
                        ? df.format(_birthDate!)
                        : 'Tap to select',
                  ),
                ),
              ),
              TextFormField(
                controller: _addressController,
                maxLength: 50,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _nikController,
                decoration: InputDecoration(labelText: 'NIK (16 digits)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (v.trim().length != 16) return 'Must be 16 digits';
                  return null;
                },
              ),
              TextFormField(
                controller: _salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                v == null || int.tryParse(v.trim()) == null
                    ? 'Enter valid number'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEmployee,
                child: Text(isEditing ? 'Update' : 'Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
