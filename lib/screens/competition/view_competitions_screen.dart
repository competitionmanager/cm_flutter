import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/team.dart';
import 'package:cm_flutter/screens/competition/view_competition_screen.dart';
import 'package:cm_flutter/screens/team/view_team_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewCompetitionsScreen extends StatefulWidget {
  @override
  _ViewCompetitionsScreenState createState() => _ViewCompetitionsScreenState();
}

class _ViewCompetitionsScreenState extends State<ViewCompetitionsScreen> {
  FirestoreProvider db = FirestoreProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: StreamBuilder(
        stream: db.getCompetitions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return buildItem(snapshot.data.documents[index]);
            },
          );
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'View Competitions',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  ListTile buildItem(DocumentSnapshot doc) {
    Competition comp = Competition.fromMap(doc.data);

    return ListTile(
      title: Text(comp.name),
      subtitle: Text(comp.organizer),
      trailing: IconButton(
        icon: Icon(
          Icons.delete_forever,
          color: Colors.black,
        ),
        onPressed: () {
          db.deleteCompetition(comp.id);
        },
      ),
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => ViewCompetitionScreen(compId: comp.id),
        );
        Navigator.of(context).push(route);
      },
    );
  }
}
