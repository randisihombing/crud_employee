import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/employee_provider.dart';
import 'employee_form_screen.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  void _showExportJsonDialog(BuildContext context) {
    final employees = context.read<EmployeeProvider>().employees;
    final jsonList = employees.map((e) => e.toJson()).toList();

    final jsonString = _prettyPrintJson(jsonList);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Exported JSON'),
        content: SingleChildScrollView(
          child: SelectableText(jsonString),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  String _prettyPrintJson(List<Map<String, dynamic>> jsonList) {
    try {
      return JsonEncoder.withIndent('  ').convert(jsonList);
    } catch (e) {
      return 'Error converting to JSON: $e';
    }
  }


  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final employees = employeeProvider.employees;

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            tooltip: 'Export JSON',
            onPressed: () {
              _showExportJsonDialog(context);
            },
          ),
        ],
      ),
      body: employees.isEmpty
          ? Center(child: Text('No employee data available.'))
          : ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final emp = employees[index];
          return ListTile(
            title: Text(emp.fullName),
            subtitle: Text('NIK: ${emp.nik}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmployeeFormScreen(
                          employee: emp,
                          index: index,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Confirm Delete'),
                        content: Text('Are you sure you want to delete this employee?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<EmployeeProvider>().deleteEmployee(index);
                              Navigator.pop(context);
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EmployeeFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
