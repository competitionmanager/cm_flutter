import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/screens/competition/view_competition_screen.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:flutter/material.dart';

class CreateCompetitionScreen extends StatefulWidget {
  @override
  _CreateCompetitionScreenState createState() =>
      _CreateCompetitionScreenState();
}

class _CreateCompetitionScreenState extends State<CreateCompetitionScreen> {
  FirestoreProvider db;
  TextEditingController competitionNameController;
  TextEditingController organizerController;
  TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
    competitionNameController = TextEditingController();
    organizerController = TextEditingController();
    locationController = TextEditingController();
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
                ColorGradientButton(
                  text: 'Create Competition',
                  color: Colors.green,
                  onPressed: () {
                    String id = db.addCompetition(
                        competitionNameController.text,
                        organizerController.text,
                        locationController.text);

                    Route route = MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ViewCompetitionScreen(compId: id),
                    );
                    Navigator.of(context).pushReplacement(route);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Builds the description text and the text field.
  Column buildCreateForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: competitionNameController,
          decoration: InputDecoration(
            labelText: 'Competition Name',
            icon: Icon(Icons.event),
          ),
        ),
        SizedBox(height: 16.0),
        TextField(
          controller: organizerController,
          decoration: InputDecoration(
            labelText: 'Organizer',
            icon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: locationController,
          decoration: InputDecoration(
            labelText: 'Location',
            icon: Icon(Icons.location_on),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Create Competition',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      leading: BackButton(),
    );
  }
}
