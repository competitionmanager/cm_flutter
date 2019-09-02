import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateDropdownBox extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  const DateDropdownBox({
    @required this.date,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                DateFormat('MM/dd/yy').format(date),
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
