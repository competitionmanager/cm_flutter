import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/view_competition_screen.dart';
import 'package:cm_flutter/styles/colors.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/date_dropdown_box.dart';
import 'package:cm_flutter/widgets/label_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';
import 'dart:io';

class CreateCompetitionScreen extends StatefulWidget {
  final FirebaseUser user;

  CreateCompetitionScreen(this.user);

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
  File competitionImage;
  String imageUrl;

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
    imageUrl = '';
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
            Divider(color: Colors.black26),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: buildCreateButton(context),
            ),
          ],
        ),
      ),
    );
  }

  ColorGradientButton buildCreateButton(BuildContext context) {
    return ColorGradientButton(
      text: 'Create Competition',
      color: kMintyGreen,
      onPressed: () async {
        if (compDate != null &&
            competitionNameController.text != '' &&
            organizerController.text != '' &&
            locationController.text != '' &&
            competitionImage != null) {
          List<String> admins = [widget.user.uid];
          List<String> savedUsers = [widget.user.uid];
          Competition comp = db.addCompetition(
            name: competitionNameController.text,
            organizer: organizerController.text,
            location: locationController.text,
            date: compDate,
            imageUrl: imageUrl,
            admins: admins,
            savedUsers: savedUsers,
          );
          await db.uploadToFirebaseStorage(competitionImage, comp.id);
          Route route = MaterialPageRoute(
            builder: (BuildContext context) =>
                ViewCompetitionScreen(comp, widget.user),
          );
          Navigator.of(context).pushReplacement(route);
        }
      },
    );
  }

  Future uploadImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      competitionImage = image;
    });
  }

  GestureDetector buildPhotoContainer(BuildContext context) {
    if (competitionImage == null) {
      return GestureDetector(
        onTap: () {
          uploadImage(context);
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
            color: Colors.black26,
          ),
          child: Center(
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
    } else {
      return GestureDetector(
        onTap: () {
          uploadImage(context);
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.file(competitionImage, fit: BoxFit.cover),
              Center(
                child: Container(
                  width: 100.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Edit photo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<DateTime> pickDate() async {
    DateTime compDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
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
