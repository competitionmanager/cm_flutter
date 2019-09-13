import 'package:cm_flutter/auth/auth_provider.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:cm_flutter/screens/competition/schedule/event/edit_event_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final String scheduleId;
  final Competition competition;
  final VoidCallback onPressed;

  EventCard({this.competition, this.scheduleId, this.event, this.onPressed});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final FirestoreProvider db = FirestoreProvider();
  bool isEditing = true; // Debugging purposes for now

  final AuthProvider authProvider = AuthProvider();

  bool isUserSubscribed = false;

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
  void didUpdateWidget(EventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Checks if user is subscribed to the events loaded
    List<dynamic> subscribers = widget.event.subscribers;
    AuthProvider auth = AuthProvider();
    if (subscribers != null) {
      if (subscribers.length == 0) isUserSubscribed = false;
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        buildTimeContainer(startTime, endTime),
        SizedBox(width: 36.0),
        Expanded(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.event.name != ''
                          ? Text(
                              widget.event.name,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500
                              ),
                              overflow: TextOverflow.ellipsis,
                            )
                          : Text(
                              'Empty',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                      SizedBox(height: 6.0),
                      Text(
                        widget.event.description,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                !isEditing
                    ? IconButton(
                        icon: !isUserSubscribed
                            ? Icon(
                                Icons.star_border,
                                color: Colors.blueAccent,
                                size: 32.0,
                              )
                            : Icon(
                                Icons.star,
                                color: Colors.blueAccent,
                                size: 32.0,
                              ),
                        onPressed: () async {
                          if (!isUserSubscribed) {
                            FirebaseUser user =
                                await authProvider.getCurrentUser();
                            db.addSubscriber(widget.competition.id,
                                widget.scheduleId, widget.event.id, user);
                            setState(() {
                              isUserSubscribed = true;
                            });
                          } else {
                            FirebaseUser user =
                                await authProvider.getCurrentUser();
                            db.removeSubscriber(widget.competition.id,
                                widget.scheduleId, widget.event.id, user);
                            setState(() {
                              isUserSubscribed = false;
                            });
                          }
                          widget.onPressed();
                        },
                      )
                    : buildEditButton()
              ],
            ),
          ),
        )
      ],
    );
  }

  Container buildTimeContainer(String startTime, String endTime) {
    return Container(
      // Lines up times in a vertical line regardless of length
      width: MediaQuery.of(context).size.width / 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            startTime,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          SizedBox(height: 6.0),
          Text(
            endTime,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  IconButton buildEditButton() {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => EditEventScreen(
            competition: widget.competition,
            scheduleId: widget.scheduleId,
            event: widget.event,
          ),
        );
        Navigator.of(context).push(route);
      },
    );
  }
}
