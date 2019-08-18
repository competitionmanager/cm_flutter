import 'package:cm_flutter/auth/auth_provider.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final String compId;
  final FirestoreProvider db = FirestoreProvider();
  final AuthProvider authProvider = AuthProvider();

  EventCard({this.event, this.compId});

  @override
  Widget build(BuildContext context) {
    String startTime = DateFormat.jm().format(event.startTime);
    String endTime = DateFormat.jm().format(event.endTime);
    return Row(
      children: <Widget>[
        Text(
          '$startTime - $endTime',
          style: TextStyle(color: Colors.black54, fontSize: 12.0),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: Container(
            height: 54.0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 8.0),
                  Text(
                    event.name,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.star_border,
                      color: Colors.black12,
                    ),
                    onPressed: () async {
                      print('event subscribed');
                      FirebaseUser user = await authProvider.getCurrentUser();
                      db.addSubscriber(compId, event.id, user);
                    },
                  )
                ],
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
