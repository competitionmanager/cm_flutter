import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/fcm/message_provider.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/edit_competition_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/schedule_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ViewCompetitionScreen extends StatefulWidget {
  final String compId;

  ViewCompetitionScreen({this.compId});

  @override
  _ViewCompetitionScreenState createState() => _ViewCompetitionScreenState();
}

class _ViewCompetitionScreenState extends State<ViewCompetitionScreen> {
  FirestoreProvider db;
  MessageProvider messageProvider;
  Competition competition;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
    // Allows alert dialogs to show up when notification received.
    messageProvider = MessageProvider(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: db.getCompetitionStream(widget.compId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SlidingUpPanel(
                minHeight: 100.0,
                maxHeight: MediaQuery.of(context).size.height,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                panel: buildSchedulePanel(snapshot.data),
                body: Stack(
                  children: <Widget>[
                    buildScreen(context),
                    buildAppBar(context)
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  SchedulePanel buildSchedulePanel(DocumentSnapshot doc) {
    competition = Competition.fromMap(doc.data);
    return SchedulePanel(competition: competition);
  }

  Row buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Route route = MaterialPageRoute(
              builder: (BuildContext context) =>
                  EditCompetitionScreen(competition: competition),
            );
            Navigator.of(context).push(route);
          },
        )
      ],
    );
  }

  Widget getImage() {
    if (competition.image_url != null) {
      // Get image from Firebase Storage
      print("Image URL: " + competition.image_url);
      return Image.network(competition.image_url, fit: BoxFit.cover);
    } else {
      // Photo N/A
      return Center(
        child: Text("Photo not available")
      );
    }
  }

  Container buildPhotoContainer(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: getImage()
    );
  }

  Widget buildScreen(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                buildPhotoContainer(context),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          competition.name,
                          style: TextStyle(
                              fontSize: 32.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'by ${competition.organizer}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 32.0),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: Colors.black26,
                              size: 28.0,
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              DateFormat('EEE, MMMM d, yyyy')
                                  .format(competition.date),
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.black26,
                              size: 28.0,
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              competition.location,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.0),
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          competition.description,
                          style: TextStyle(fontSize: 16.0),
                        )
                      ],
                    ))
              ],
            ),
          )
        ]);
  }
}
