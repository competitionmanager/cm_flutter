import 'package:cm_flutter/auth/auth_provider.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:cm_flutter/screens/competition/schedule/event/edit_event_screen.dart';
import 'package:cm_flutter/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final String scheduleId;
  final Competition competition;
  final FirebaseUser user;
  final bool isEditing;
  final EventStatus eventStatus;
  final VoidCallback onSelect;
  final int timeChange;

  EventCard({
    this.competition,
    this.scheduleId,
    this.event,
    this.user,
    this.isEditing,
    this.eventStatus,
    this.onSelect,
    this.timeChange,
    Key key
  }) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final FirestoreProvider db = FirestoreProvider();
  final AuthProvider authProvider = AuthProvider();

  bool isUserSubscribed = false;
  bool isAdmin = false;
  bool selected = false;

  Color timeTextColor = Colors.black;

  @override
  void initState() {
    super.initState();
    isAdmin = widget.competition.admins.contains(widget.user.uid);

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
    // If not in edit mode, select all cards.
    selected = !widget.isEditing;
    // If time is getting changed, change it to preview.
    // applyTimeChangePreview();
  }

  void applyTimeChangePreview() {
    if (widget.timeChange < 0) {
      widget.event.startTime = widget.event.startTime.subtract(Duration(minutes: widget.timeChange));
      widget.event.endTime = widget.event.startTime.subtract(Duration(minutes: widget.timeChange));
      timeTextColor = kWarningRed;
    } else
    if (widget.timeChange > 0) {
      widget.event.startTime = widget.event.startTime.add(Duration(minutes: widget.timeChange));
      widget.event.endTime = widget.event.endTime.add(Duration(minutes: widget.timeChange));
      timeTextColor = kMintyGreen;
    } else {
      timeTextColor = Colors.black;
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
    print("update widget");
    applyTimeChangePreview();
  }

  Color determineOpacity(Color color) {
    if (selected) {
      return color;
    }

    double newOpacity = color.opacity - 0.5;
    newOpacity = newOpacity < 0.25 ? 0.25 : newOpacity;

    return color.withOpacity(newOpacity);
  }

  Color determineBorderColor() {
    if (selected) {
      if (widget.eventStatus == EventStatus.advanced) {
        return kMintyGreen;
      } else if (widget.eventStatus == EventStatus.delayed) {
        return kWarningRed;
      } else if (widget.eventStatus == EventStatus.noChange) {
        return Colors.black;
      }
    }
    return Colors.black12;
  }

  @override
  Widget build(BuildContext context) {
    String startTime = DateFormat.jm().format(widget.event.startTime);
    String endTime = DateFormat.jm().format(widget.event.endTime);

    return GestureDetector(
      onTap: () {
        if (widget.isEditing) {
          setState(() {
            selected = !selected;
          });
          widget.onSelect();
        }
      },
      child: AnimatedContainer(
        height: 75.0,
        duration: Duration(milliseconds: 50),
        decoration: widget.isEditing
            ? BoxDecoration(
                // color: Colors.white,
                color: selected ? Colors.white : Colors.white38,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: determineBorderColor(), width: 2.0),
              )
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            widget.event.name != ''
                                ? Text(
                                    widget.event.name,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: determineOpacity(Colors.black),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Text(
                                    'Empty',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: determineOpacity(Colors.black54),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            SizedBox(height: 6.0),
                            Text(
                              widget.event.description,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: determineOpacity(Colors.black54),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      isAdmin
                          ? buildAdminButton()
                          : IconButton(
                              icon: !isUserSubscribed
                                  ? Icon(
                                      Icons.star_border,
                                      color: kMintyGreen,
                                      size: 32.0,
                                    )
                                  : Icon(
                                      Icons.star,
                                      color: kMintyGreen,
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
                              },
                            )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildTimeContainer(String startTime, String endTime) {
    return Container(
      // Lines up times in a vertical line regardless of length
      width: MediaQuery.of(context).size.width / 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            startTime,
            style: TextStyle(
              color: selected ? timeTextColor : determineOpacity(Colors.black),
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 6.0),
          Text(
            endTime,
            style: TextStyle(
              color: selected ? timeTextColor : determineOpacity(Colors.black),
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  IconButton buildEditButton() {
    return IconButton(
      icon: Icon(Icons.edit),
      color: determineOpacity(Colors.black),
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

  Widget buildAdminButton() {
    if (widget.isEditing) {
      return buildEditButton();
    } else {
      return Container();
    }
  }
}
