import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/schedule.dart';
import 'package:cm_flutter/screens/competition/schedule/schedule_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditScheduleScreen extends StatefulWidget {
  final Competition competition;
  final FirebaseUser user;

  EditScheduleScreen({this.competition, this.user});

  @override
  _EditScheduleScreenState createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  int currentTabIndex = 0;
  FirestoreProvider db = FirestoreProvider();
  List<Schedule> events = List();

  QuerySnapshot data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.95),
      appBar: buildAppBar(),
      body: SafeArea(
        child: StreamBuilder(
          // TODO: Don't get schedules again.
          stream: db.getSchedules(widget.competition.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.documents.length == 0) {
              return Center(
                child: Text(
                  'No Schedules Found :(',
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              );
            } else {
              data = snapshot.data;
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ScheduleView(
                      competition: widget.competition,
                      data: data,
                      user: widget.user,
                      isEditing: true,
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      leading: IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: Text(
        'Edit Schedule',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.check,
            color: Colors.black,
            size: 24.0,
          ),
          onPressed: () {
            // TODO: Save chanages to firebase
            print("Save changes");
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
