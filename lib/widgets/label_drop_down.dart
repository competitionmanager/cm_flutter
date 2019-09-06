import 'package:cm_flutter/models/schedule.dart';
import 'package:flutter/material.dart';

class LabelDropDown extends StatefulWidget {
  final String labelText;
  final List<Schedule> schedules;
  final Widget dropDownButton;

  LabelDropDown({@required this.labelText, @required this.schedules, @required this.dropDownButton});

  @override
  _LabelDropDownState createState() => _LabelDropDownState();
}

class _LabelDropDownState extends State<LabelDropDown> {
  int currentIndex = 0; // The index of the displayed drop down item.

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.labelText,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.0),
        Container(
          height: 60.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: widget.dropDownButton,
          ),
        ),
      ],
    );
  }
}
