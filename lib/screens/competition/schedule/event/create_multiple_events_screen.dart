import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/schedule.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/label_drop_down.dart';
import 'package:cm_flutter/widgets/label_text_field.dart';
import 'package:cm_flutter/widgets/time_dropdown_box.dart';
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
      _CreateMultipleEventsScreenState();
}

class _CreateMultipleEventsScreenState
    extends State<CreateMultipleEventsScreen> {
  FirestoreProvider db;
  TextEditingController numTeamsController;
  TextEditingController eventDurationController;
  TextEditingController breakDurationController;

  TimeOfDay startTime;
  DateTime startDateTime;

  int currentIndex;

  @override
  void initState() {
    super.initState();

    db = FirestoreProvider();

    numTeamsController = TextEditingController();
    eventDurationController = TextEditingController();
    breakDurationController = TextEditingController();

    currentIndex = widget.currentTabIndex;
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
            children: <Widget>[
              buildCreateForm(),
              ColorGradientButton(
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
                  }
                  Navigator.of(context).pop();
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
      initialTime: TimeOfDay.now(),
    );

    DateTime eventDate = widget.competition.date;
    if (time != null) {
      DateTime date = DateTime(eventDate.year, eventDate.month, eventDate.day,
          time.hour, time.minute);
      return date;
    }
  }

  Widget buildTimeDropdownBox(TimeOfDay time) {
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
            setState(() {
              startDateTime = date;
              startTime = TimeOfDay.fromDateTime(date);
            });
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

  Expanded buildCreateForm() {
    return Expanded(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Text(
            'Start Time',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
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
            schedules: widget.schedules,
            dropDownButton: buildDropdownButton(),
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
