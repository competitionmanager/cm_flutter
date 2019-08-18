import 'package:cm_flutter/auth/auth_provider.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:cm_flutter/screens/competition/schedule/edit_event_screen.dart';
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

    // Checks if user is subscribed to the events loaded.
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
        Column(
          children: <Widget>[
            Text(
              startTime,
              style: TextStyle(color: Colors.black54, fontSize: 12.0),
            ),
            Text(
              endTime,
              style: TextStyle(color: Colors.black54, fontSize: 12.0),
            ),
          ],
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Route route = MaterialPageRoute(
                builder: (BuildContext context) => EditEventScreen(
                  compId: widget.compId,
                  event: widget.event,
                ),
              );
              Navigator.of(context).push(route);
            },
            child: Container(
              height: 54.0,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        widget.event.name,
                        style: TextStyle(fontSize: 18.0),
                      ),
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
                          FirebaseUser user =
                              await authProvider.getCurrentUser();
                          db.addSubscriber(
                              widget.compId, widget.event.id, user);
                          setState(() {
                            isUserSubscribed = true;
                          });
                        } else {
                          FirebaseUser user =
                              await authProvider.getCurrentUser();
                          db.removeSubscriber(
                              widget.compId, widget.event.id, user);
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
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ),
        )
      ],
    );
  }
}
