import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  final String compId;

  CreateEventScreen({this.compId});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  FirestoreProvider db;
  TextEditingController eventNameController;
  TimeOfDay startTime;
  TimeOfDay endTime;
  DateTime startDateTime;
  DateTime endDateTime;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
    eventNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildCreateForm(),
                ColorGradientButton(
                  text: 'Create Event',
                  color: Colors.blue,
                  onPressed: () {
                    db.addEvent(widget.compId, eventNameController.text, startDateTime, endDateTime);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime> pickTime() async {
    TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
    );
    // TODO: replace date with event date
    DateTime eventDate = DateTime.now();
    if (time != null) {
      DateTime date = DateTime(eventDate.year, eventDate.month, eventDate.day, time.hour, time.minute);
      return date;
    }
  }

  // Builds the description text and the text field.
  Column buildCreateForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: eventNameController,
          decoration: InputDecoration(
            labelText: 'Event Name',
            icon: Icon(Icons.event),
          ),
        ),
        SizedBox(height: 32.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.access_time),
            SizedBox(width: 16.0),
            buildTimeDropdownBox(startTime, true),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: Icon(Icons.arrow_forward),
            ),
            buildTimeDropdownBox(endTime, false),
          ],
        )
      ],
    );
  }

  Expanded buildTimeDropdownBox(TimeOfDay time, bool isStartTime) {
    String text;
    if (time == null) {
      text = isStartTime ? 'Start Time' : 'End Time';
    } else {
      String hour = time.hourOfPeriod.toString();
      if (hour == '0') hour = '12';
      String minute;
      time.minute < 10 ? minute = '0${time.minute.toString()}' : minute = time.minute.toString();
      String period = time.hour < 12 ? 'AM' : 'PM';
      text = '$hour:$minute $period';
    }
    return Expanded(
      child: GestureDetector(
        onTap: () {
          pickTime().then((date) {
            if (isStartTime) {
              setState(() {
                startDateTime = date;
                startTime = TimeOfDay.fromDateTime(date);
              });
            } else {
              setState(() {
                endDateTime = date;
                endTime = TimeOfDay.fromDateTime(date);
              });
            }
          });
        },
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(text),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
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
