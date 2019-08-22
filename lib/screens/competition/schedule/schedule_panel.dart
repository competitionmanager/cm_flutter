import 'package:cm_flutter/screens/competition/schedule/create_event_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/event_card_list.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:flutter/material.dart';

class SchedulePanel extends StatelessWidget {
  final String compId;

  SchedulePanel({this.compId});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
              Text(
                'View Schedule',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: EventCardList(compId: compId),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: ColorGradientButton(
              text: 'Create an Event',
              color: Colors.blue,
              onPressed: () {
                // db.addDummyEvents(widget.compId);
                Route route = MaterialPageRoute(
                  builder: (BuildContext context) => CreateEventScreen(
                    compId: compId,
                  ),
                );
                Navigator.of(context).push(route);
              },
            ),
          ),
        ],
      ),
    );
  }
}