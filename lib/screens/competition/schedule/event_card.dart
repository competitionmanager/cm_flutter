import 'package:cm_flutter/models/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({this.event});

  @override
  Widget build(BuildContext context) {
    String startTime = DateFormat.jm().format(event.startTime);
    String endTime = DateFormat.jm().format(event.endTime);
    return Row(
      children: <Widget>[
        Text(
          '$startTime - $endTime',
          style: TextStyle(color: Colors.black54),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: Container(
            height: 54.0,
            child: Center(
              child: Text(
                event.name,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
        )
      ],
    );
  }
}
