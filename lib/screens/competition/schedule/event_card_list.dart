import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:cm_flutter/widgets/competition/event_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventCardList extends StatefulWidget {
  final Competition competition;
  final String scheduleId;
  final FirebaseUser user;

  EventCardList({this.competition, this.scheduleId, this.user});

  @override
  _EventCardListState createState() => _EventCardListState();
}

class _EventCardListState extends State<EventCardList> {
  final FirestoreProvider db = FirestoreProvider();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.getSchedule(
        compId: widget.competition.id,
        scheduleId: widget.scheduleId,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return Column(
            children: <Widget>[
              SizedBox(height: 128.0),
              Text(
                'No Events Found :(',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ],
          );
        }
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: buildItem(snapshot.data.documents[index]),
                ),
              ],
            );
          },
        );
      },
    );
  }

  EventCard buildItem(DocumentSnapshot doc) {
    Event event = Event.fromMap(doc.data);
    return EventCard(
      event: event,
      scheduleId: widget.scheduleId,
      competition: widget.competition,
      user: widget.user,
      onPressed: () {
        setState(() {});
      },
    );
  }
}
