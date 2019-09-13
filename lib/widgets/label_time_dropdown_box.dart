import 'package:flutter/material.dart';

class LabelTimeDropdownBox extends StatefulWidget {
  final String labelText;
  final TimeOfDay time;
  final VoidCallback onTap;

  LabelTimeDropdownBox({@required this.labelText, @required this.time, @required this.onTap});

  @override
  _LabelTimeDropdownBoxState createState() => _LabelTimeDropdownBoxState();
}

class _LabelTimeDropdownBoxState extends State<LabelTimeDropdownBox> {
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
        buildTimeDropdownBox(),
      ],
    );
  }

  Widget buildTimeDropdownBox() {
    String text = '';
    if (widget.time != null) {
      String hour = widget.time.hourOfPeriod.toString();
      if (hour == '0') hour = '12';
      String minute;
      widget.time.minute < 10
          ? minute = '0${widget.time.minute.toString()}'
          : minute = widget.time.minute.toString();
      String period = widget.time.hour < 12 ? 'AM' : 'PM';
      text = '$hour:$minute $period';
    }
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: 60.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(fontSize: 16.0),
              ),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
