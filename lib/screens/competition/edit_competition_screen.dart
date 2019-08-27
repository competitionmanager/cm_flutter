import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/view_competition_screen.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:flutter/material.dart';

class EditCompetitionScreen extends StatefulWidget {
  final Competition competition;

  EditCompetitionScreen({this.competition});

  @override
  _EditCompetitionScreenState createState() => _EditCompetitionScreenState();
}

class _EditCompetitionScreenState extends State<EditCompetitionScreen> {
  FirestoreProvider db;
  TextEditingController competitionNameController;
  TextEditingController organizerController;
  TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
    competitionNameController = TextEditingController();
    competitionNameController.text = widget.competition.name;
    organizerController = TextEditingController();
    organizerController.text = widget.competition.organizer;
    locationController = TextEditingController();
    locationController.text = widget.competition.location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: competitionNameController,
                decoration: InputDecoration(
                    labelText: 'Name', border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 32.0,
              ),
              TextField(
                controller: organizerController,
                decoration: InputDecoration(
                    labelText: 'Organizer', border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 32.0,
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                    labelText: 'Location', border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 32.0,
              ),
              ColorGradientButton(
                text: 'Delete Competition',
                color: Colors.red,
                onPressed: () {
                  db.deleteCompetition(widget.competition.id);
                  Navigator.of(context).pop();
                },
              ),
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
                ViewCompetitionScreen(compId: widget.competition.id),
          );
          Navigator.of(context).pushReplacement(route);
        },
      ),
      title: Text(
        'Edit Competition',
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
                'name': competitionNameController.text,
                'organizer': organizerController.text,
                'location': locationController.text,
              };
              db.updateCompetition(widget.competition.id, data);
              Route route = MaterialPageRoute(
                builder: (BuildContext context) =>
                    ViewCompetitionScreen(compId: widget.competition.id),
              );
              Navigator.of(context).pushReplacement(route);
            },
          ),
        )
      ],
    );
  }
}
