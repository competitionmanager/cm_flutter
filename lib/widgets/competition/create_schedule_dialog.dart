import 'package:cm_flutter/styles/colors.dart';
import 'package:flutter/material.dart';

class CreateScheduleDialog extends StatefulWidget {
  final TextEditingController textEditingController;
  final VoidCallback onCreatePressed;

  CreateScheduleDialog({@required this.textEditingController, @required this.onCreatePressed});

  @override
  _CreateScheduleDialogState createState() => _CreateScheduleDialogState();
}

class _CreateScheduleDialogState extends State<CreateScheduleDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: 180.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'New Schedule',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: widget.textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.onCreatePressed,
              child: Container(
                height: 48.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kMintyGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}