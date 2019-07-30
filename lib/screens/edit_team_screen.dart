import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/team.dart';
import 'package:cm_flutter/screens/view_team_screen.dart';
import 'package:flutter/material.dart';

class EditTeamScreen extends StatefulWidget {
  final Team team;

  EditTeamScreen({this.team});

  @override
  _EditTeamScreenState createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends State<EditTeamScreen> {
  FirestoreProvider db;
  TextEditingController teamNameController;
  TextEditingController teamBioController;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
    teamNameController = TextEditingController();
    teamNameController.text = widget.team.name;
    teamBioController = TextEditingController();
    teamBioController.text = widget.team.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: teamNameController,
                decoration: InputDecoration(
                    labelText: 'Name', border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 32.0,
              ),
              TextField(
                controller: teamBioController,
                decoration: InputDecoration(
                    labelText: 'Bio', border: OutlineInputBorder()),
                maxLines: 5,
              ),
              SizedBox(
                height: 32.0,
              ),
              buildDeleteButton(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Route route = MaterialPageRoute(
            builder: (BuildContext context) =>
                ViewTeamScreen(teamId: widget.team.id),
          );
          Navigator.of(context).pushReplacement(route);
        },
      ),
      title: Text(
        'Edit Team',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.check,
              size: 32.0,
            ),
            onPressed: () {
              Map<String, dynamic> data = {
                'name': teamNameController.text,
                'bio': teamBioController.text
              };
              db.updateTeam(widget.team.id, data);
              Route route = MaterialPageRoute(
                builder: (BuildContext context) =>
                    ViewTeamScreen(teamId: widget.team.id),
              );
              Navigator.of(context).pushReplacement(route);
            },
          ),
        )
      ],
    );
  }

  SizedBox buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: RaisedButton(
        child: Text(
          'Delete Team',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onPressed: () {
          db.deleteTeam(widget.team.id);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
