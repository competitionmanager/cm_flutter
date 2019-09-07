import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/schedule.dart';
import 'package:cm_flutter/styles/colors.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/label_drop_down.dart';
import 'package:cm_flutter/widgets/label_text_field.dart';
import 'package:cm_flutter/widgets/time_dropdown_box.dart';
import 'package:flutter/material.dart';

class CreateSingleEventScreen extends StatefulWidget {
  final Competition competition;

  // Used to list the available schedules to add the event to.
  final List<Schedule> schedules;

  // Used to choose the default schedule selection.
  final int currentTabIndex;

  CreateSingleEventScreen(
      {@required this.competition,
      @required this.schedules,
      @required this.currentTabIndex});

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

  int currentIndex;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
    eventNameController = TextEditingController();
    currentIndex = widget.currentTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            buildCreateForm(),
            Divider(color: Colors.black26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ColorGradientButton(
                text: 'Create Event',
                color: kMintyGreen,
                onPressed: () {
                  if (eventNameController.text != null &&
                      startDateTime != null &&
                      endDateTime != null) {
                    db.addEvent(
                      widget.competition.id,
                      widget.schedules[currentIndex].id,
                      eventNameController.text,
                      startDateTime,
                      endDateTime,
                    );
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Start Time',
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TimeDropdownBox(
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
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TimeDropdownBox(
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
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                LabelDropDown(
                  labelText: "Schedule",
                  schedules: widget.schedules,
                  dropDownButton: buildDropdownButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DropdownButton buildDropdownButton() {
    return DropdownButton(
      isExpanded: true,
      underline: Container(),
      value: currentIndex,
      onChanged: (value) {
        setState(() {
          currentIndex = value;
        });
      },
      items: getMenuItems(),
    );
  }

  List<DropdownMenuItem> getMenuItems() {
    List<DropdownMenuItem> items = List();
    for (int i = 0; i < widget.schedules.length; i++) {
      items.add(
        DropdownMenuItem(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(widget.schedules[i].name),
            ),
          ),
          value: i,
        ),
      );
    }
    return items;
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
