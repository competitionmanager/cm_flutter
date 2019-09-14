import 'package:cm_flutter/screens/competition_list/competition_list.dart';
import 'package:cm_flutter/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CM',
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}