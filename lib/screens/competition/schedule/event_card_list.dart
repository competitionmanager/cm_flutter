import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/models/event.dart';
import 'package:cm_flutter/widgets/event_card.dart';
import 'package:flutter/material.dart';
class EventCardList extends StatefulWidget {
  final Competition competition;
  final String scheduleId;

  EventCardList({this.competition, this.scheduleId});

  @override
  _EventCardListState createState() => _EventCardListState();
}

class _EventCardListState extends State<EventCardList> {
  final FirestoreProvider db = FirestoreProvider();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // stream: db.getEvents(widget.schedule.id),
      stream: db.getSchedule(compId: widget.competition.id, scheduleId: widget.scheduleId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                buildItem(snapshot.data.documents[index]),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Divider(color: Colors.black45),
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
      competition: widget.competition,
      onPressed: () {
        setState(() {});
      },
    );
  }
}
