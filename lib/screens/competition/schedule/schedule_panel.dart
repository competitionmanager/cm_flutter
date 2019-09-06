import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/schedule.dart';
import 'package:cm_flutter/screens/competition/schedule/event/create_multiple_events_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/event/create_single_event_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/event_card_list.dart';
import 'package:cm_flutter/widgets/tab_item.dart';
import 'package:flutter/material.dart';

class SchedulePanel extends StatefulWidget {
  final Competition competition;

  SchedulePanel({this.competition});

  @override
  _SchedulePanelState createState() => _SchedulePanelState();
}

class _SchedulePanelState extends State<SchedulePanel> {
  FirestoreProvider db = FirestoreProvider();
  List<Schedule> schedules = List();
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.getSchedules(widget.competition.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data.documents.length == 0) {
          return Column(
            children: <Widget>[
              SizedBox(height: 16.0),
              Container(
                // Rectangle oval decoration
                width: 64.0,
                height: 7.5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              SizedBox(height: 16.0),
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                centerTitle: true,
                title: Text(
                  'View Schedule',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 32.0,
                      ),
                      onPressed: () {
                        buildModalBottomSheet(context,
                            documents: snapshot.data.documents);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 64.0),
              Text(
                'There aren\'t any schedules yet :(',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black45, fontSize: 18.0),
              )
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 16.0),
                  Container(
                    // Rectangle oval decoration
                    width: 64.0,
                    height: 7.5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    centerTitle: true,
                    title: Text(
                      'View Schedule',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    actions: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 32.0,
                          ),
                          onPressed: () {
                            buildModalBottomSheet(context,
                                documents: snapshot.data.documents);
                          },
                        ),
                      ),
                    ],
                  ),
                  buildTabView(snapshot.data)
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: EventCardList(
                    competition: widget.competition,
                    scheduleId:
                        snapshot.data.documents[currentTabIndex].data['id'],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Padding buildTabView(QuerySnapshot data) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        height: 35.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            return TabItem(
              tabText: data.documents[index]['name'],
              tabIsSelected: index == currentTabIndex,
              onTabSelected: () {
                setState(() {
                  currentTabIndex = index;
                });
              },
            );
          },
        ),
      ),
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
                    title: Text('Create a Single Event'),
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
                    title: Text('Create Multiple Events'),
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
