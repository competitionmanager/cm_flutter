import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/screens/competition/view_competition_screen.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/date_dropdown_box.dart';
import 'package:cm_flutter/widgets/label_text_field.dart';
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
  DateTime compDate;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
    competitionNameController = TextEditingController();
    competitionNameController.text = '';
    organizerController = TextEditingController();
    organizerController.text = '';
    locationController = TextEditingController();
    locationController.text = '';
    compDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            buildCreateForm(),
            buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  Padding buildCreateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ColorGradientButton(
        text: 'Create Competition',
        color: Color.fromRGBO(0, 210, 150, 1.0),
        onPressed: () {
          if (compDate != null &&
              competitionNameController.text != '' &&
              organizerController.text != '' &&
              locationController.text != '') {

            String id = db.addCompetition(
              name: competitionNameController.text,
              organizer: organizerController.text,
              location: locationController.text,
              date: compDate,
            );

            Route route = MaterialPageRoute(
              builder: (BuildContext context) =>
                  ViewCompetitionScreen(compId: id),
            );
            Navigator.of(context).pushReplacement(route);
          }
        },
      ),
    );
  }

  Container buildPhotoContainer(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(
        child: GestureDetector(
          onTap: () {
            print('Upload photo');
          },
          child: Container(
            width: 100.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                'Upload photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime> pickDate() async {
    DateTime compDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    return compDate;
  }

  // Builds the description text and the text field.
  Expanded buildCreateForm() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          buildPhotoContainer(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LabelTextField(
                  labelText: 'Competition Name',
                  textController: competitionNameController,
                ),
                SizedBox(height: 8.0),
                LabelTextField(
                  labelText: 'Organizer',
                  textController: organizerController,
                ),
                SizedBox(height: 8.0),
                LabelTextField(
                  labelText: 'Location',
                  textController: locationController,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: DateDropdownBox(
                    date: compDate,
                    onTap: () {
                      pickDate().then((date) {
                        if (date != null) {
                          setState(() {
                            compDate = date;
                          });
                        }
                      });
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
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
