import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:cm_flutter/models/schedule.dart';
import 'package:cm_flutter/styles/colors.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/label_text_field.dart';
import 'package:cm_flutter/widgets/label_time_dropdown_box.dart';
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
  TextEditingController descriptionController;
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

    descriptionController = TextEditingController();
    descriptionController.text = widget.event.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildEditForm(),
              Divider(color: Colors.black26),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: ColorGradientButton(
                  text: 'Delete Event',
                  color: kWarningRed,
                  onPressed: () {
                    db.deleteEvent(widget.competition.id, widget.scheduleId,
                        widget.event.id);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditForm() {
    return Expanded(
      child: ListView(
        // physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                LabelTextField(
                  labelText: 'Event Name',
                  textController: eventNameController,
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: LabelTimeDropdownBox(
                        labelText: 'Start Time',
                        time: startTime,
                        onTap: () {
                          pickTime().then((date) {
                            if (date != null) {
                              setState(() {
                                startDateTime = date;
                                startTime = TimeOfDay.fromDateTime(date);
                              });
                            }
                          });
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                          bottom: 15.0,
                        ),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: LabelTimeDropdownBox(
                        labelText: 'End Time',
                        time: endTime,
                        onTap: () {
                          pickTime().then((date) {
                            if (date != null) {
                              setState(() {
                                endDateTime = date;
                                endTime = TimeOfDay.fromDateTime(date);
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                LabelTextField(
                  labelText: 'Event Description',
                  textController: descriptionController,
                  isParagraph: true,
                ),
              ],
            ),
          ),
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
              db.updateEvent(
                widget.competition.id,
                widget.scheduleId,
                widget.event.id,
                eventNameController.text,
                startDateTime,
                endDateTime,
                descriptionController.text,
              );
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }
}
