import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/schedule/event/create_multiple_events_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/event/create_single_event_screen.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  final Competition competition;

  CreateEventScreen({this.competition});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  bool isCreatingSingleEvent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 32.0,
            right: 32.0,
            bottom: 16.0,
          ),
          child: CreateSingleEventScreen(competition: widget.competition),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Create Event',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      leading: BackButton(),
    );
  }
}
