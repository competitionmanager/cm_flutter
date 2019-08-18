import 'package:cm_flutter/auth/auth_provider.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final String compId;
  final VoidCallback onPressed;

  EventCard({this.event, this.compId, this.onPressed});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final FirestoreProvider db = FirestoreProvider();

  final AuthProvider authProvider = AuthProvider();

  bool isUserSubscribed = false;

  Future<Event> checkSubscribers(Event event) async {
    Event newEvent = event;
    List<dynamic> subscribers = event.subscribers;
    AuthProvider auth = AuthProvider();

    if (subscribers != null) {
      subscribers.forEach((id) async {
        FirebaseUser user = await auth.getCurrentUser();
        if (user.uid == id) {
          newEvent.isUserSubscribed = true;
        }
      });
    }
    return newEvent;
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    List<dynamic> subscribers = widget.event.subscribers;
    AuthProvider auth = AuthProvider();
    if (subscribers != null) {
      subscribers.forEach((id) {
        auth.getCurrentUser().then((user) {
          if (user.uid == id) {
            setState(() {
              isUserSubscribed = true;
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String startTime = DateFormat.jm().format(widget.event.startTime);
    String endTime = DateFormat.jm().format(widget.event.endTime);
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
                    widget.event.name,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  IconButton(
                    icon: !isUserSubscribed
                        ? Icon(
                            Icons.star_border,
                            color: Colors.black12,
                          )
                        : Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                    onPressed: () async {
                      if (!isUserSubscribed) {
                        print('event subscribed');
                        FirebaseUser user = await authProvider.getCurrentUser();
                        db.addSubscriber(widget.compId, widget.event.id, user);
                        setState(() {
                          isUserSubscribed = true;
                        });
                      } else {
                        print('event unsubscribed');
                        FirebaseUser user = await authProvider.getCurrentUser();
                        db.removeSubscriber(widget.compId, widget.event.id, user);
                        setState(() {
                          isUserSubscribed = false;
                        });
                      }
                      widget.onPressed();
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
