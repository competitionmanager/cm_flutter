import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:cm_flutter/models/schedule.dart';
import 'package:cm_flutter/screens/competition/schedule/event/create_multiple_events_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/event/create_single_event_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/event_card_list.dart';
import 'package:cm_flutter/styles/colors.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/competition/create_schedule_dialog.dart';
import 'package:cm_flutter/widgets/competition/delay_option.dart';
import 'package:cm_flutter/widgets/competition/event_card.dart';
import 'package:cm_flutter/widgets/tab_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ScheduleView extends StatefulWidget {
  final Competition competition;
  final QuerySnapshot data;
  final FirebaseUser user;
  final bool isEditing;

  ScheduleView({
    @required this.competition,
    @required this.data,
    @required this.user,
    @required this.isEditing,
  });

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  FirestoreProvider db = FirestoreProvider();
  int currentTabIndex = 0;

  EventStatus eventStatus = EventStatus.noChange;

  TextEditingController newScheduleNameController = TextEditingController();

  List<Event> events = List();
  List<EventCard> eventCards = List();

  int timeChange = 0;

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  Future<void> getEvents() async {
    events.clear();
    eventCards.clear();
    QuerySnapshot snapshot = await db.getEvents(
      compId: widget.competition.id,
      scheduleId: widget.data.documents[currentTabIndex].data['id'],
    );
    for (int i = 0; i < snapshot.documents.length; i++) {
      setState(() {
        Event event = Event.fromMap(snapshot.documents[i].data);
        eventCards.add(buildEventCard(event));
      });
    }
  }

  EventCard buildEventCard(Event event) {
    return EventCard(
      event: event,
      scheduleId: widget.data.documents[currentTabIndex].data['id'],
      competition: widget.competition,
      user: widget.user,
      isEditing: widget.isEditing,
      eventStatus: eventStatus,
      onSelect: () {
        // events.contain(event) did not work.
        bool eventFound =
            events.firstWhere((e) => e.id == event.id, orElse: () => null) !=
                null;
        if (eventFound) {
          setState(() {
            events.removeWhere((e) => e.id == event.id);
          });
        } else {
          setState(() {
            events.add(event);
          });
        }
      },
      key: ValueKey(widget.data.documents[currentTabIndex].data['id']),
      timeChange: timeChange,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildTabView(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            child: EventCardList(
              competition: widget.competition,
              scheduleId: widget.data.documents[currentTabIndex].data['id'],
              user: widget.user,
              isEditing: widget.isEditing,
              eventStatus: eventStatus,
              eventCards: eventCards,
            ),
          ),
        ),
        widget.isEditing ? buildEditButtonBar() : buildAddButtonBar(),
      ],
    );
  }

  Widget buildTabView() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Container(
        height: 35.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // If not editing, show the add button.
          itemCount: widget.isEditing
              ? widget.data.documents.length
              : widget.data.documents.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == widget.data.documents.length) {
              return buildAddScheduleButton(context);
            }
            return buildTabItem(index);
          },
        ),
      ),
    );
  }

  TabItem buildTabItem(int index) {
    return TabItem(
      tabText: widget.data.documents[index]['name'],
      tabIsSelected: index == currentTabIndex,
      onTabSelected: () {
        setState(() {
          currentTabIndex = index;
        });
        getEvents();
      },
    );
  }

  GestureDetector buildAddScheduleButton(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6.0),
        child: Icon(Icons.add),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => CreateScheduleDialog(
            textEditingController: newScheduleNameController,
            onCreatePressed: () {
              if (newScheduleNameController.text != '') {
                db.addSchedule(
                  compId: widget.competition.id,
                  name: newScheduleNameController.text,
                );
                Navigator.of(context).pop();
              }
            },
          ),
        );
      },
    );
  }

  void onEventDelayed() {
    setState(() {
      timeChange++;
      onEventTimeChange();
    });
  }

  void onEventAdvanced() {
    setState(() {
      timeChange--;
      onEventTimeChange();
    });
  }

  void onEventTimeChange() {
    if (timeChange < 0) {
      eventStatus = EventStatus.advanced;
    } else if (timeChange > 0) {
      eventStatus = EventStatus.delayed;
    } else {
      eventStatus = EventStatus.noChange;
    }
  }

  // void updateEventCardList() {
  //   for (int i = 0; i < events.length; i++) {
  //     // Selected event
  //     Event event = events[i];
  //     // Find the selected event in the event card list
  //     bool eventFound = eventCards.firstWhere((e) => e.event.id == event.id,
  //             orElse: () => null) !=
  //         null;

  //     if (eventFound) {
  //       setState(() {
  //         eventCards.removeWhere((e) => e.event.id == event.id);

  //         if (timeChange < 0) {
  //           event.startTime =
  //               event.startTime.subtract(Duration(minutes: timeChange));
  //           event.endTime =
  //               event.startTime.subtract(Duration(minutes: timeChange));
  //         } else if (timeChange > 0) {
  //           event.startTime =
  //               event.startTime.add(Duration(minutes: timeChange));
  //           event.endTime = event.endTime.add(Duration(minutes: timeChange));
  //         }
  //         eventCards.add(buildEventCard(event));
  //       });
  //     } else {
  //       setState(() {
  //         events.add(event);
  //       });
  //     }
  //   }
  // }

  Visibility buildEditButtonBar() {
    return Visibility(
      visible: widget.competition.admins.contains(widget.user.uid),
      child: Column(
        children: <Widget>[
          DelayOption(
            onEventAdvanced: onEventAdvanced,
            onEventDelayed: onEventDelayed,
          ),
          Divider(
            color: Colors.black26,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 8.0,
            ),
            child: Row(
              children: <Widget>[
                Flexible(child: buildDeleteButton()),
                SizedBox(width: 8.0),
                Flexible(child: buildSaveButton()),
              ],
            ),
          )
        ],
      ),
    );
  }

  ColorGradientButton buildDeleteButton() {
    return ColorGradientButton(
      text: 'Delete',
      color: kWarningRed,
      onPressed: () {
        db.deleteSchedule(
          compId: widget.competition.id,
          scheduleId: widget.data.documents[currentTabIndex].data['id'],
        );
        setState(() {
          currentTabIndex = 0;
        });
      },
    );
  }

  ColorGradientButton buildSaveButton() {
    return ColorGradientButton(
        text: 'Save',
        color: kMintyGreen,
        onPressed: () {
          events.forEach((event) {
            DateTime newStartTime;
            DateTime newEndTime;
            newStartTime = event.startTime.add(Duration(minutes: timeChange));
            newEndTime = event.endTime.add(Duration(minutes: timeChange));
            db
                .updateEvent(
              widget.competition.id,
              widget.data.documents[currentTabIndex].data['id'],
              event.id,
              event.name,
              newStartTime,
              newEndTime,
              event.description,
            )
                .then((response) {
              Navigator.pop(context, true);
            });
          });
        });
  }

  Visibility buildAddButtonBar() {
    return Visibility(
      visible: widget.competition.admins.contains(widget.user.uid),
      child: Column(
        children: <Widget>[
          Divider(
            color: Colors.black26,
          ),
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
                buildModalBottomSheet(
                  context,
                  documents: widget.data.documents,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Future buildModalBottomSheet(BuildContext context,
      {List<DocumentSnapshot> documents}) {
    List<Schedule> schedules = List();

    if (documents != null) {
      for (int i = 0; i < documents.length; i++) {
        schedules.add(Schedule.fromMap(documents[i].data));
      }
    }

    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        child: SafeArea(
          child: Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Create a single event'),
                    onTap: () {
                      Navigator.pop(context);
                      Route route = MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CreateSingleEventScreen(
                          competition: widget.competition,
                          schedules: schedules,
                          currentTabIndex: currentTabIndex,
                        ),
                      );
                      Navigator.of(context).push(route);
                    },
                  ),
                  ListTile(
                    title: Text('Create multiple events'),
                    onTap: () {
                      Navigator.pop(context);
                      Route route = MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CreateMultipleEventsScreen(
                          competition: widget.competition,
                          schedules: schedules,
                          currentTabIndex: currentTabIndex,
                        ),
                      );
                      getEvents();
                      Navigator.of(context).push(route);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
