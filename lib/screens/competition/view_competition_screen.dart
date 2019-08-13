import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/edit_competition_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewCompetitionScreen extends StatefulWidget {
  final String compId;

  ViewCompetitionScreen({this.compId});

  @override
  _ViewCompetitionScreenState createState() => _ViewCompetitionScreenState();
}

class _ViewCompetitionScreenState extends State<ViewCompetitionScreen> {
  FirestoreProvider db;
  Competition competition;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildAppBar(context),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder(
                  stream: db.getCompetition(widget.compId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      );
                    return _buildScreen(snapshot.data);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            Navigator.of(context).pushReplacement(route);
          },
        )
      ],
    );
  }

  Widget _buildScreen(DocumentSnapshot doc) {
    competition = Competition.fromMap(doc.data);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          doc['name'],
          style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.0),
        Text(
          'by ${doc['organizer']}',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 32.0),
        Row(
          children: <Widget>[
            Icon(
              Icons.date_range,
              color: Colors.black87,
              size: 28.0,
            ),
            SizedBox(width: 16.0),
            Text(
              doc['date'],
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          children: <Widget>[
            Icon(
              Icons.location_on,
              color: Colors.black87,
              size: 28.0,
            ),
            SizedBox(width: 16.0),
            Text(
              doc['location'],
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
        )
      ],
    );
  }
}
