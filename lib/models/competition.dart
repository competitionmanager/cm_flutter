import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

Competition competitionFromJson(String str) =>
    Competition.fromMap(json.decode(str));

String competitionToJson(Competition data) => json.encode(data.toMap());

class Competition {
  String id;
  String name;
  String organizer;
  String location;
  DateTime date;
  String description;

  Competition({
    this.id,
    this.name,
    this.organizer,
    this.location,
    this.date,
    this.description,
  });

  factory Competition.fromMap(Map<String, dynamic> json) {
    return Competition(
      id: json["id"],
      name: json["name"],
      organizer: json["organizer"],
      location: json["location"],
      date: json["date"].toDate(),
      description: json["description"],
    );
  }

  factory Competition.fromDocumentSnapshot(DocumentSnapshot data) {
    return Competition(
      id: data["id"],
      name: data["name"],
      organizer: data["organizer"],
      location: data["location"],
      date: data["date"].toDate(),
      description: data["description"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "organizer": organizer,
        "location": location,
        "date": date,
        "description": description
      };

  String toString() {
    String output = '';
    output += 'Competition Object: {\n\t';
    output += 'id: $id\n\t';
    output += 'name: $name\n\t';
    output += 'organizer: $organizer\n\t';
    output += 'location: $location\n\t';
    output += 'date: $date\n\t';
    output += 'description: $description\n';
    output += '}\n';
    return output;
  }
}
