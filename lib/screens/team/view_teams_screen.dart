import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/team.dart';
import 'package:cm_flutter/screens/team/view_team_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewTeamsScreen extends StatefulWidget {
  @override
  _ViewTeamsScreenState createState() => _ViewTeamsScreenState();
}

class _ViewTeamsScreenState extends State<ViewTeamsScreen> {
  FirestoreProvider db = FirestoreProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: StreamBuilder(
        stream: db.getTeams(),
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
        'View Teams',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              db.addTeams();
            },
          ),
        )
      ],
    );
  }

  ListTile buildItem(DocumentSnapshot doc) {
    Team team = Team.fromMap(doc.data);

    return ListTile(
      title: Text(team.name),
      subtitle: Text(team.bio),
      trailing: IconButton(
        icon: Icon(
          Icons.delete_forever,
          color: Colors.black,
        ),
        onPressed: () {
          db.deleteTeam(team.id);
        },
      ),
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => ViewTeamScreen(teamId: team.id),
        );
        Navigator.of(context).push(route);
      },
    );
  }
}
