import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/schedule/event_card_list.dart';
import 'package:cm_flutter/styles/colors.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/tab_item.dart';
import 'package:flutter/material.dart';

class ScheduleView extends StatefulWidget {
  final Competition competition;
  final QuerySnapshot data;

  ScheduleView({@required this.competition, @required this.data});

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  FirestoreProvider db = FirestoreProvider();
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildTabView(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 16.0,
              right: 16.0,
            ),
            child: EventCardList(
              competition: widget.competition,
              scheduleId: widget.data.documents[currentTabIndex].data['id'],
            ),
          ),
        ),
        Divider(
          color: Colors.black26,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 8.0,
          ),
          child: ColorGradientButton(
            text: 'Delete Schedule',
            color: kWarningRed,
            onPressed: () {
              db.deleteSchedule(
                compId: widget.competition.id,
                scheduleId: widget.data.documents[currentTabIndex].data['id'],
              );
              setState(() {
                currentTabIndex = 0;
              });
            },
          ),
        )
      ],
    );
  }

  Widget buildTabView() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Container(
        height: 35.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            return TabItem(
              tabText: widget.data.documents[index]['name'],
              tabIsSelected: index == currentTabIndex,
              onTabSelected: () {
                setState(() {
                  currentTabIndex = index;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
