import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  TopBar({this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      actions: actions
    );
  }
}
