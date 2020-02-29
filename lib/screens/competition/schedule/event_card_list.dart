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
  final bool isEditing;
  final EventStatus eventStatus;

  EventCardList({
    this.competition,
    this.scheduleId,
    this.user,
    this.isEditing,
    this.eventStatus,
  });

  @override
  _EventCardListState createState() => _EventCardListState();
}

class _EventCardListState extends State<EventCardList> {
  final FirestoreProvider db = FirestoreProvider();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.getEvents(
        compId: widget.competition.id,
        scheduleId: widget.scheduleId,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return buildNoEventsFoundContainer();
        }
        return buildEventCardList(snapshot);
      },
    );
  }

  ListView buildEventCardList(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.documents.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: buildEventCard(snapshot.data.documents[index]),
            ),
          ],
        );
      },
    );
  }

  Column buildNoEventsFoundContainer() {
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

  EventCard buildEventCard(DocumentSnapshot doc) {
    Event event = Event.fromMap(doc.data);
    return EventCard(
      event: event,
      scheduleId: widget.scheduleId,
      competition: widget.competition,
      user: widget.user,
      onPressed: () {
        setState(() {});
      },
      isEditing: widget.isEditing,
      eventStatus: widget.eventStatus,
    );
  }
}
