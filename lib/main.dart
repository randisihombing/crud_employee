import 'package:crud_employee/provider/auth_provider.dart';
import 'package:crud_employee/provider/employee_provider.dart';
import 'package:crud_employee/provider/joke_provider.dart';
import 'package:crud_employee/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'model/employee_model.dart';
import 'model/joke_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(JokeAdapter());

  await Hive.openBox<Employee>('employees');
  await Hive.openBox<Joke>('jokes');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => JokeProvider()),
      ],
      child: MaterialApp(
        title: 'Employee App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginScreen(),
      ),
    );
  }
}
