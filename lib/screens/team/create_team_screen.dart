import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/screens/team/view_team_screen.dart';
import 'package:flutter/material.dart';

class CreateTeamScreen extends StatefulWidget {
  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  FirestoreProvider db;
  TextEditingController teamNameController;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
    teamNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 128.0,
              left: 32.0,
              right: 32.0,
              bottom: 32.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildCreateForm(),
                buildCreateButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds a custom create button
  SizedBox buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: RaisedButton(
        child: Text(
          'Create Team',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onPressed: () {
          String id = db.addTeam(teamNameController.text);

          Route route = MaterialPageRoute(
            builder: (BuildContext context) => ViewTeamScreen(teamId: id),
          );
          Navigator.of(context).pushReplacement(route);
        },
      ),
    );
  }

  // Builds the description text and the text field.
  Column buildCreateForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'Create a team',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.0),
        Text('What is the name of your team?'),
        SizedBox(height: 16.0),
        TextField(
          controller: teamNameController,
        )
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Create Team',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      leading: BackButton(),
    );
  }
}
