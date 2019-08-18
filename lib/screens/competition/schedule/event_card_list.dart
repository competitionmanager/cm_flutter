import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:cm_flutter/screens/competition/schedule/event_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCardList extends StatelessWidget {
  final FirestoreProvider db = FirestoreProvider();
  final String compId;

  EventCardList({this.compId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.getEvents(compId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: buildItem(snapshot.data.documents[index]),
            );
          },
        );
      },
    );
  }

  EventCard buildItem(DocumentSnapshot doc) {
    Event event = Event.fromMap(doc.data);
    return EventCard(event: event);
  }
}
