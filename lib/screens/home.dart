import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dad_jokes/dadjokes_screen.dart';
import '../employee/employee_list_screen.dart';
import '../face_recognation/face_detection_screen.dart';
import '../provider/auth_provider.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  void _logout(BuildContext context) {
    context.read<AuthProvider>().logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EmployeeListScreen()),
                );
              },
              child: Text('CRUD'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DadJokesScreen()),
                );
              },
              child: Text('DadJokes'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => FaceDetectionScreen()),
            //     );
            //   },
            //   child: Text('Face Detection'),
            // ),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),

          ],
        ),
      ),
    );
  }
}
