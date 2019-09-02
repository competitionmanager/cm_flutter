import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/date_dropdown_box.dart';
import 'package:cm_flutter/widgets/label_text_field.dart';
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
  DateTime compDate;

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
    compDate = widget.competition.date;
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
        text: 'Delete Competition',
        color: Color.fromRGBO(225, 30, 30, 1.0),
        onPressed: () {
          db.deleteCompetition(widget.competition.id);
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
        'Edit Competition',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      leading: BackButton(),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.check,
              size: 32.0,
            ),
            onPressed: () {
              if (compDate != null &&
                  competitionNameController.text != '' &&
                  organizerController.text != '' &&
                  locationController.text != '') {
                Map<String, dynamic> data = {
                  'name': competitionNameController.text,
                  'organizer': organizerController.text,
                  'location': locationController.text,
                  'date': compDate,
                };

                db.updateCompetition(widget.competition.id, data);
                Navigator.pop(context);
              }
            },
          ),
        )
      ],
    );
  }
}
