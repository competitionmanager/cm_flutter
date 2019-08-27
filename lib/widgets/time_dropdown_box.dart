import 'package:flutter/material.dart';

class TimeDropdownBox extends StatelessWidget {
  final TimeOfDay time;
  final VoidCallback onTap;

  const TimeDropdownBox({
    @required this.time,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String text = '';
    if (time != null) {
      String hour = time.hourOfPeriod.toString();
      if (hour == '0') hour = '12';
      String minute;
      time.minute < 10
          ? minute = '0${time.minute.toString()}'
          : minute = time.minute.toString();
      String period = time.hour < 12 ? 'AM' : 'PM';
      text = '$hour:$minute $period';
    }
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 50.0,
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
