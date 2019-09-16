import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/schedule.dart';
import 'package:cm_flutter/utils/datetime_provider.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/competition/create_schedule_dialog.dart';
import 'package:cm_flutter/widgets/label_drop_down.dart';
import 'package:cm_flutter/widgets/label_text_field.dart';
import 'package:cm_flutter/widgets/label_time_dropdown_box.dart';
import 'package:flutter/material.dart';

class CreateMultipleEventsScreen extends StatefulWidget {
  final Competition competition;

  // Used to list the available schedules to add the event to.
  final List<Schedule> schedules;

  // Used to choose the default schedule selection.
  final int currentTabIndex;

  CreateMultipleEventsScreen(
      {this.competition, this.schedules, this.currentTabIndex});

  @override
  _CreateMultipleEventsScreenState createState() =>
      _CreateMultipleEventsScreenState(schedules: schedules);
}

class _CreateMultipleEventsScreenState
    extends State<CreateMultipleEventsScreen> {
  List<Schedule> schedules;

  DateTimeProvider dateTimeProvider;
  FirestoreProvider db;

  TextEditingController numTeamsController;
  TextEditingController eventDurationController;
  TextEditingController breakDurationController;
  TextEditingController newScheduleNameController;

  TimeOfDay startTime;
  DateTime startDateTime;

  int currentIndex;

  _CreateMultipleEventsScreenState({this.schedules});

  @override
  void initState() {
    super.initState();

    dateTimeProvider = DateTimeProvider();

    db = FirestoreProvider();

    numTeamsController = TextEditingController();
    numTeamsController.text = '';
    eventDurationController = TextEditingController();
    eventDurationController.text = '';
    breakDurationController = TextEditingController();
    breakDurationController.text = '';
    newScheduleNameController = TextEditingController();
    newScheduleNameController.text = '';

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
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: buildCreateButton(),
            ),
          ],
        ),
      ),
    );
  }

  ColorGradientButton buildCreateButton() {
    return ColorGradientButton(
      text: 'Create Event',
      color: Color.fromRGBO(0, 210, 150, 1.0),
      onPressed: () {
        if (startTime != null &&
            numTeamsController.text != '' &&
            eventDurationController.text != '' &&
            breakDurationController.text != '') {
          db.addEvents(
            compId: widget.competition.id,
            scheduleId: widget.schedules[currentIndex].id,
            startTime: startDateTime,
            numTeams: int.parse(numTeamsController.text),
            eventDuration: int.parse(eventDurationController.text),
            breakDuration: int.parse(breakDurationController.text),
          );

          Navigator.of(context).pop();
        }
      },
    );
  }

  Future<DateTime> pickTime() async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    DateTime eventDate = widget.competition.date;
    if (time != null) {
      DateTime date = DateTime(eventDate.year, eventDate.month, eventDate.day,
          time.hour, time.minute);
      return date;
    }
  }

  Expanded buildCreateForm() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LabelTimeDropdownBox(
                  labelText: 'Start Time',
                  time: startTime,
                  onTap: () {
                    dateTimeProvider
                        .pickTime(context, widget.competition.date)
                        .then((date) {
                      if (date != null) {
                        setState(() {
                          startDateTime = date;
                          startTime = TimeOfDay.fromDateTime(date);
                        });
                      }
                    });
                  },
                ),
                SizedBox(height: 16.0),
                LabelTextField(
                  labelText: 'Number of Teams',
                  textController: numTeamsController,
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                LabelTextField(
                  labelText: 'Event Duration',
                  textController: eventDurationController,
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                LabelTextField(
                  labelText: 'Break Duration',
                  textController: breakDurationController,
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                LabelDropDown(
                  labelText: "Schedule",
                  schedules: schedules,
                  dropDownButton: buildDropdownButton(),
                  actionButton: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => CreateScheduleDialog(
                          textEditingController: newScheduleNameController,
                          onCreatePressed: () {
                            // TODO: Need error message pop up
                            if (newScheduleNameController.text != '') {
                              String id = db.addSchedule(
                                compId: widget.competition.id,
                                name: newScheduleNameController.text,
                              );
                              setState(() {
                                schedules.add(
                                  Schedule(
                                    id: id,
                                    name: newScheduleNameController.text,
                                  ),
                                );
                                currentIndex = schedules.length - 1;
                              });
                              // Upload new schedule tab and delete this item.
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      );
                    },
                  ),
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
