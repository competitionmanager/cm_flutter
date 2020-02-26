import 'package:cm_flutter/styles/colors.dart';
import 'package:flutter/material.dart';

class DelayOption extends StatefulWidget {
  @override
  _DelayOptionState createState() => _DelayOptionState();
}

class _DelayOptionState extends State<DelayOption> {
  int delayTime = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: Icon(
            Icons.remove,
            size: 36.0,
            color: delayTime < 0 ? kWarningRed : Colors.black,
          ),
          onTap: () {
            setState(() {
              delayTime--;
            });
          },
        ),
        SizedBox(width: 16.0),
        Container(
          height: 36.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "$delayTime minutes",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.0),
        GestureDetector(
          child: Icon(
            Icons.add,
            size: 36.0,
            color: delayTime > 0 ? kMintyGreen : Colors.black,
          ),
          onTap: () {
            setState(() {
              delayTime++;
            });
          },
        ),
      ],
    );
  }
}
