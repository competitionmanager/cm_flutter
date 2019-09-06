import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/event.dart';

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
  String image_url;

  Competition({
    this.id,
    this.name,
    this.organizer,
    this.location,
    this.date,
    this.description,
    this.image_url,
  });

  factory Competition.fromMap(Map<String, dynamic> json) {
    return Competition(
      id: json["id"],
      name: json["name"],
      organizer: json["organizer"],
      location: json["location"],
      date: json["date"].toDate(),
      description: json["description"],
      image_url: json["image_url"],
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "organizer": organizer,
        "location": location,
        "date": date,
        "description": description,
        "image_url": image_url,
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
    output += 'image_url: $image_url\n';
    output += '}\n';
    return output;
  }
}
