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
  final List<EventCard> eventCards;

  EventCardList({
    this.competition,
    this.scheduleId,
    this.user,
    this.isEditing,
    this.eventStatus,
    this.eventCards,
  });

  @override
  _EventCardListState createState() => _EventCardListState();
}

class _EventCardListState extends State<EventCardList> {
  final FirestoreProvider db = FirestoreProvider();

  List<Event> events = List();

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder(
    //   stream: db.getEventsStream(
    //     compId: widget.competition.id,
    //     scheduleId: widget.scheduleId,
    //   ),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData || snapshot.data.documents.length == 0) {
    //       return Center(
    //         child: Text(
    //           'No Events Found :(',
    //           style: TextStyle(
    //             fontSize: 24.0,
    //           ),
    //         ),
    //       );
    //     } else {
    //       return Column(
    //         children: <Widget>[
    //           Padding(
    //             padding: const EdgeInsets.only(bottom: 12.0),
    //             child: widget.eventCards[index],
    //           ),
    //         ],
    //       );
    //     }
    //   },
    // );
    return ListView.builder(
      itemCount: widget.eventCards.length,
      itemBuilder: (context, index) {
        if (widget.eventCards.length == 0) {
          return buildNoEventsFoundContainer();
        }
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: widget.eventCards[index],
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
}
