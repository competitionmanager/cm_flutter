import 'package:flutter/material.dart';

class DelayOption extends StatefulWidget {
  final VoidCallback onEventDelayed;
  final VoidCallback onEventAdvanced;

  DelayOption({
    this.onEventDelayed,
    this.onEventAdvanced,
  });

  @override
  _DelayOptionState createState() => _DelayOptionState();
}

class _DelayOptionState extends State<DelayOption> {
  int timeChange = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildAdvanceButton(),
            SizedBox(width: 32.0),
            buildDelayTimeDisplay(),
            SizedBox(width: 32.0),
            buildDelayButton(),
          ],
        ),
      ),
    );
  }

  Center buildDelayTimeDisplay() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "$timeChange min",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
          ),
        ),
      ),
    );
  }

  GestureDetector buildDelayButton() {
    return GestureDetector(
      child: Icon(
        Icons.add,
        size: 36.0,
        color: Colors.black,
      ),
      onTap: () {
        setState(() {
          timeChange++;
        });
        widget.onEventDelayed();
      },
    );
  }

  GestureDetector buildAdvanceButton() {
    return GestureDetector(
      child: Icon(
        Icons.remove,
        size: 36.0,
        color: Colors.black,
      ),
      onTap: () {
        setState(() {
          timeChange--;
        });
        widget.onEventAdvanced();
      },
    );
  }
}
