import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/schedule.dart';
import 'package:cm_flutter/screens/competition/schedule/event/create_multiple_events_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/event/create_single_event_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/schedule_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewScheduleScreen extends StatefulWidget {
  final Competition competition;
  final FirebaseUser user;

  ViewScheduleScreen({this.competition, this.user});

  @override
  _ViewScheduleScreenState createState() => _ViewScheduleScreenState();
}

class _ViewScheduleScreenState extends State<ViewScheduleScreen> {
  int currentTabIndex = 0;
  FirestoreProvider db = FirestoreProvider();
  List<Schedule> schedules = List();

  QuerySnapshot data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: StreamBuilder(
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
                      data: snapshot.data,
                      user: widget.user,
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
      leading: BackButton(),
      centerTitle: true,
      title: Text(
        'View Schedule',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      actions: <Widget>[
        Visibility(
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black,
                size: 32.0,
              ),
              onPressed: () {
                  buildModalBottomSheet(
                    context,
                    documents: data != null ? data.documents : null,
                  );
              },
            ),
            visible: widget.competition.admins.contains(widget.user.uid))
      ],
    );
  }

  Future buildModalBottomSheet(BuildContext context,
      {List<DocumentSnapshot> documents}) {
    List<Schedule> schedules = List();

    if (documents != null) {
      for (int i = 0; i < documents.length; i++) {
        schedules.add(Schedule.fromMap(documents[i].data));
      }
    }

    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        child: SafeArea(
          child: Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Create a single event'),
                    onTap: () {
                      Navigator.pop(context);
                      Route route = MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CreateSingleEventScreen(
                          competition: widget.competition,
                          schedules: schedules,
                          currentTabIndex: currentTabIndex,
                        ),
                      );
                      Navigator.of(context).push(route);
                    },
                  ),
                  ListTile(
                    title: Text('Create multiple events'),
                    onTap: () {
                      Navigator.pop(context);
                      Route route = MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CreateMultipleEventsScreen(
                          competition: widget.competition,
                          schedules: schedules,
                          currentTabIndex: currentTabIndex,
                        ),
                      );
                      Navigator.of(context).push(route);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
