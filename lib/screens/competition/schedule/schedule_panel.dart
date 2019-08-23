import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/schedule/event/create_event_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/event/create_multiple_events_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/event/create_single_event_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/event_card_list.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:flutter/material.dart';

class SchedulePanel extends StatefulWidget {
  final Competition competition;

  SchedulePanel({this.competition});

  @override
  _SchedulePanelState createState() => _SchedulePanelState();
}

class _SchedulePanelState extends State<SchedulePanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(height: 16.0),
            Container(
              width: 64.0,
              height: 7.5,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            SizedBox(height: 16.0),
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                'View Schedule',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 32.0,
                    ),
                    onPressed: () {
                      buildModalBottomSheet(context);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 24.0,
              right: 24.0,
            ),
            child: EventCardList(competition: widget.competition),
          ),
        ),
      ],
    );
  }

  Future buildModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => 
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                )
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text('Create a Single Event'),
                    onTap: () {
                      Navigator.pop(context);
                      Route route = MaterialPageRoute(
                        builder: (BuildContext context) => CreateSingleEventScreen(
                          competition: widget.competition,
                        ),
                      );
                      Navigator.of(context).push(route);
                    },
                  ),
                  ListTile(
                    title: Text('Create Multiple Events'),
                    onTap: () {
                      Navigator.pop(context);
                      Route route = MaterialPageRoute(
                        builder: (BuildContext context) => CreateMultipleEventsScreen(
                          competition: widget.competition,
                        ),
                      );
                      Navigator.of(context).push(route);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
