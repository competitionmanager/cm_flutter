import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:flutter/material.dart';

class CreateMultipleEventsScreen extends StatefulWidget {
  final Competition competition;

  CreateMultipleEventsScreen({this.competition});
  
  @override
  _CreateMultipleEventsScreenState createState() => _CreateMultipleEventsScreenState();
}

class _CreateMultipleEventsScreenState extends State<CreateMultipleEventsScreen> {
  FirestoreProvider db;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 32.0,
            right: 32.0,
            bottom: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Create Event',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      leading: BackButton(),
    );
  }
}