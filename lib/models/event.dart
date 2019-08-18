import 'dart:convert';

import 'package:cm_flutter/auth/auth_provider.dart';

Event eventFromJson(String str) => Event.fromMap(json.decode(str));

String eventToJson(Event data) => json.encode(data.toMap());

class Event {
  String name;
  DateTime startTime;
  DateTime endTime;
  String id;
  bool isUserSubcribed;

  Event({
    this.name,
    this.startTime,
    this.endTime,
    this.id,
    this.isUserSubcribed,
  });

  factory Event.fromMap(Map<String, dynamic> json) {
    AuthProvider auth = AuthProvider();
    DateTime startTime = json['startTime'].toDate();
    DateTime endTime = json['endTime'].toDate();
    bool isUserSubscribed = false;

    List<dynamic> subscribers;
    subscribers = json['subscribers'];
    
    if (subscribers != null) {
      subscribers.forEach((id) {
        auth.getCurrentUser().then((user) {
          String userId = user.uid;
          if (userId == id) isUserSubscribed = true;
        });
      });
    }

    // print(isUserSubscribed);
    return Event(
      name: json["name"],
      startTime: startTime,
      endTime: endTime,
      id: json["id"],
      isUserSubcribed: isUserSubscribed,
    );
  }

  Map<String, dynamic> toMap() => {
        "name": name,
        "startTime": startTime,
        "endTime": endTime,
        "id": id,
      };
}
