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
}