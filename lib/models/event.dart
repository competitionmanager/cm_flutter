import 'dart:convert';

import 'package:cm_flutter/auth/auth_provider.dart';

Event eventFromJson(String str) => Event.fromMap(json.decode(str));

String eventToJson(Event data) => json.encode(data.toMap());

class Event {
  String name;
  DateTime startTime;
  DateTime endTime;
  String id;
  List<dynamic> subscribers;
  bool isUserSubscribed;

  Event({
    this.name,
    this.startTime,
    this.endTime,
    this.id,
    this.subscribers,
    this.isUserSubscribed,
  });

  factory Event.fromMap(Map<String, dynamic> json) {
    DateTime startTime = json['startTime'].toDate();
    DateTime endTime = json['endTime'].toDate();
    bool isUserSubscribed = false;

    return Event(
      name: json["name"],
      startTime: startTime,
      endTime: endTime,
      id: json["id"],
      subscribers: json["subscribers"],
      isUserSubscribed: isUserSubscribed,
    );
  }

  Map<String, dynamic> toMap() => {
        "name": name,
        "startTime": startTime,
        "endTime": endTime,
        "id": id,
      };

    String toString() {
      String output = '';
      output += 'Event Object: {\n\t';
      output += 'id: $id\n';
      output += 'name: $name\n\t';
      output += 'subscribers: $subscribers\n\t';
      output += 'isUserSubscribed: $isUserSubscribed\n\t';
      output += '}\n';
      return output;
    }
}
