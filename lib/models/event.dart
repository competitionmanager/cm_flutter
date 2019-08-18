import 'dart:convert';

Event eventFromJson(String str) => Event.fromMap(json.decode(str));

String eventToJson(Event data) => json.encode(data.toMap());

class Event {
  String name;
  DateTime startTime;
  DateTime endTime;
  String id;

  Event({
    this.name,
    this.startTime,
    this.endTime,
    this.id,
  });

  factory Event.fromMap(Map<String, dynamic> json) {
    DateTime startTime = json['startTime'].toDate();
    DateTime endTime = json['endTime'].toDate();

    return Event(
      name: json["name"],
      startTime: startTime,
      endTime: endTime,
      id: json["id"],
    );
  }

  Map<String, dynamic> toMap() => {
        "name": name,
        "startTime": startTime,
        "endTime": endTime,
        "id": id,
      };
}
