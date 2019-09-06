import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:cm_flutter/models/schedule.dart';
import 'package:cm_flutter/styles/colors.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/label_text_field.dart';
import 'package:flutter/material.dart';

class EditEventScreen extends StatefulWidget {
  final Competition competition;
  final String scheduleId;
  final Event event;

  EditEventScreen({this.competition, this.scheduleId, this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
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
    eventNameController.text = widget.event.name;
    startTime = TimeOfDay.fromDateTime(widget.event.startTime);
    endTime = TimeOfDay.fromDateTime(widget.event.endTime);

    DateTime eventDate = widget.competition.date;
    startDateTime = DateTime(eventDate.year, eventDate.month, eventDate.day,
        startTime.hour, startTime.minute);
    endDateTime = DateTime(eventDate.year, eventDate.month, eventDate.day,
        endTime.hour, endTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildEditForm(),
                ColorGradientButton(
                  text: 'Delete Event',
                  color: kWarningRed,
                  onPressed: () {
                    db.deleteEvent(widget.competition.id, widget.scheduleId, widget.event.id);
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

  Widget buildEditForm() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          LabelTextField(labelText: 'Event Name', textController: eventNameController),
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: BackButton(),
      centerTitle: true,
      title: Text(
        'Edit Event',
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
              db.updateEvent(widget.competition.id, widget.scheduleId, widget.event.id,
                  eventNameController.text, startDateTime, endDateTime);
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}
