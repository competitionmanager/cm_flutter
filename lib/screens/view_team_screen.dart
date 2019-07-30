import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/team.dart';
import 'package:cm_flutter/screens/edit_team_screen.dart';
import 'package:flutter/material.dart';

class ViewTeamScreen extends StatelessWidget {
  FirestoreProvider db = FirestoreProvider();
  final String teamId;
  Team team;

  ViewTeamScreen({this.teamId});

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
              StreamBuilder(
                stream: db.getTeam(teamId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    );
                  return _buildScreen(snapshot.data);
                },
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
              builder: (BuildContext context) => EditTeamScreen(team: team),
            );
            Navigator.of(context).pushReplacement(route);
          },
        )
      ],
    );
  }

  Widget _buildScreen(DocumentSnapshot doc) {
    team = Team.fromMap(doc.data);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            doc['name'],
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.0),
          Text(
            doc['bio'],
            style: TextStyle(
              fontSize: 18.0,
              color: Color.fromRGBO(0, 0, 0, 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
