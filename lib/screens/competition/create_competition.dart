import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/screens/competition/view_competition_screen.dart';
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
          'Create Competition',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        onPressed: () {
          String id = db.addCompetition(competitionNameController.text,
              organizerController.text, locationController.text);

          Route route = MaterialPageRoute(
            builder: (BuildContext context) => ViewCompetitionScreen(compId: id),
          );
          Navigator.of(context).pushReplacement(route);
        },
      ),
    );
  }

  // void _selectDate() async {
  //   DateTime date = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(2016),
  //       lastDate: DateTime(2020)
  //   );

  //   if(date != null) setState(() => _value = date);
  // }

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
