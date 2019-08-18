import 'package:cm_flutter/auth/auth_provider.dart';
import 'package:cm_flutter/screens/login/login_screen.dart';
import 'package:cm_flutter/screens/profile_screen.dart';
import 'package:cm_flutter/test_options_drawer.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CM',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
        elevation: 1.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: TestOptionsDrawer(),
      body: Container(),
    );
  }
}