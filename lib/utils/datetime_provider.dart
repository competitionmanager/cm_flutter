import 'package:flutter/material.dart';

class DateTimeProvider {

  Future<DateTime> pickTime(BuildContext context, DateTime eventDate) async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (time != null) {
      DateTime date = DateTime(eventDate.year, eventDate.month, eventDate.day,
          time.hour, time.minute);
      return date;
    }
  }

  Future<DateTime> pickDate(BuildContext context, DateTime initialDate) async {
    DateTime compDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDate: initialDate,
    );

    return compDate;
  }

}