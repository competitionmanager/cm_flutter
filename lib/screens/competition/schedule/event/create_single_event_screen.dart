import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/schedule.dart';
import 'package:cm_flutter/styles/colors.dart';
import 'package:cm_flutter/utils/datetime_provider.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/competition/create_schedule_dialog.dart';
import 'package:cm_flutter/widgets/label_drop_down.dart';
import 'package:cm_flutter/widgets/label_text_field.dart';
import 'package:cm_flutter/widgets/label_time_dropdown_box.dart';
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
      _CreateSingleEventScreenState(schedules: schedules);
}

class _CreateSingleEventScreenState extends State<CreateSingleEventScreen> {
  List<Schedule> schedules;

  FirestoreProvider db;
  DateTimeProvider dateTimeProvider;

  TimeOfDay startTime;
  TimeOfDay endTime;
  DateTime startDateTime;
  DateTime endDateTime;

  TextEditingController eventNameController;
  TextEditingController newScheduleNameController;

  int currentIndex;

  _CreateSingleEventScreenState({this.schedules});

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
    dateTimeProvider = DateTimeProvider();
    eventNameController = TextEditingController();
    eventNameController.text = '';
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
              child: ColorGradientButton(
                text: 'Create Event',
                color: kMintyGreen,
                onPressed: () {
                  if (eventNameController.text != 'null' &&
                      startDateTime != null &&
                      endDateTime != null &&
                      schedules != null) {
                    // If the user made a new schedule
                    db.addEvent(
                      widget.competition.id,
                      schedules[currentIndex].id,
                      eventNameController.text,
                      startDateTime,
                      endDateTime,
                    );
                    print('event added');
                    // Upload new schedule tab and delete this item.
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
                      child: LabelTimeDropdownBox(
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
                      child: LabelTimeDropdownBox(
                        labelText: 'End Time',
                        time: endTime,
                        onTap: () {
                          dateTimeProvider
                              .pickTime(context, widget.competition.date)
                              .then((date) {
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
    for (int i = 0; i < schedules.length; i++) {
      items.add(
        DropdownMenuItem(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(schedules[i].name),
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
