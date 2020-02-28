import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:cm_flutter/styles/colors.dart';
import 'package:flutter/material.dart';

class DelayOption extends StatefulWidget {
  final String competitionId;
  final String scheduleId;
  final List<DocumentSnapshot> documents;
  final int index;
  final VoidCallback onUpdate;

  DelayOption({
    this.competitionId,
    this.scheduleId,
    this.documents,
    this.index,
    this.onUpdate,
  });

  @override
  _DelayOptionState createState() => _DelayOptionState();
}

class _DelayOptionState extends State<DelayOption> {
  List<Event> events;
  int delayTime = 0;

  // Edits event times of events after the index.
  void editEventTimes(int index, bool isDelayed) {
    FirestoreProvider firestoreProvider = FirestoreProvider();

    for (int i = index + 1; i < events.length; i++) {
      Event event = events[i];
      DateTime startTime;
      DateTime endTime;
      if (isDelayed) {
        startTime = events[i].startTime.add(Duration(minutes: 1));
        endTime = events[i].endTime.add(Duration(minutes: 1));
      } else {
        startTime = events[i].startTime.subtract(Duration(minutes: 1));
        endTime = events[i].endTime.subtract(Duration(minutes: 1));
      }
      events[i].startTime = startTime;
      events[i].endTime = endTime;
      firestoreProvider.updateEvent(widget.competitionId, widget.scheduleId,
          event.id, event.name, startTime, endTime, event.description);

      widget.onUpdate();
    }
  }

  @override
  void initState() {
    super.initState();
    events = List<Event>();
    for (int i = 0; i < widget.documents.length; i++) {
      Event event = Event.fromMap(widget.documents[i].data);
      events.add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: Icon(
            Icons.remove,
            size: 36.0,
            color: delayTime < 0 ? kWarningRed : Colors.black,
          ),
          onTap: () {
            editEventTimes(widget.index, false);
            setState(() {
              delayTime--;
            });
          },
        ),
        SizedBox(width: 16.0),
        Container(
          height: 36.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "$delayTime minutes",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.0),
        GestureDetector(
          child: Icon(
            Icons.add,
            size: 36.0,
            color: delayTime > 0 ? kMintyGreen : Colors.black,
          ),
          onTap: () {
            editEventTimes(widget.index, true);
            setState(() {
              delayTime++;
            });
          },
        ),
      ],
    );
  }
}
