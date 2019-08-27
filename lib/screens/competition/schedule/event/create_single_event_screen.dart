import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:flutter/material.dart';

class CreateSingleEventScreen extends StatefulWidget {
  final Competition competition;

  CreateSingleEventScreen({this.competition});

  @override
  _CreateSingleEventScreenState createState() =>
      _CreateSingleEventScreenState();
}

class _CreateSingleEventScreenState extends State<CreateSingleEventScreen> {
  TextEditingController eventNameController;
  FirestoreProvider db;
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
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 32.0,
            right: 32.0,
            bottom: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildCreateForm(),
              SizedBox(height: 16.0),
              ColorGradientButton(
                text: 'Create Event',
                color: Colors.blue,
                onPressed: () {
                  if (eventNameController.text != null &&
                      startDateTime != null &&
                      endDateTime != null) {
                    db.addEvent(
                      widget.competition.id,
                      eventNameController.text,
                      startDateTime,
                      endDateTime,
                    );
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime> pickTime() async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: startTime != null ? startTime : TimeOfDay.now(),
    );

    DateTime eventDate = widget.competition.date;
    if (time != null) {
      DateTime date = DateTime(eventDate.year, eventDate.month, eventDate.day,
          time.hour, time.minute);
      return date;
    }
  }

  // Builds the description text and the text field.
  Widget buildCreateForm() {
    return Expanded(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Text(
            'Event Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: eventNameController,
            decoration: InputDecoration(
              hintText: 'Name of the event',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black12),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Start Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    buildTimeDropdownBox(startTime, true),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 15.0),
                  child: Icon(Icons.arrow_forward),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'End Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    buildTimeDropdownBox(endTime, false),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildTimeDropdownBox(TimeOfDay time, bool isStartTime) {
    String text = '';
    if (time != null) {
      String hour = time.hourOfPeriod.toString();
      if (hour == '0') hour = '12';
      String minute;
      time.minute < 10
          ? minute = '0${time.minute.toString()}'
          : minute = time.minute.toString();
      String period = time.hour < 12 ? 'AM' : 'PM';
      text = '$hour:$minute $period';
    }
    return GestureDetector(
      onTap: () {
        pickTime().then((date) {
          if (date != null) {
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
          }
        });
      },
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(fontSize: 16.0),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
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
