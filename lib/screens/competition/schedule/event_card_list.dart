import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:cm_flutter/screens/competition/schedule/event_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCardList extends StatefulWidget {
  final String compId;

  EventCardList({this.compId});

  @override
  _EventCardListState createState() => _EventCardListState();
}

class _EventCardListState extends State<EventCardList> {
  final FirestoreProvider db = FirestoreProvider();

  @override
  Widget build(BuildContext context) {
    print("Rebuilding...");
    return StreamBuilder(
      stream: db.getEvents(widget.compId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        print(snapshot.data.documents.length);
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
    print(event);
    return EventCard(
      event: event,
      compId: widget.compId,
      onPressed: () {
        setState(() {});
      },
    );
  }
}
