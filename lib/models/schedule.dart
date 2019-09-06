import 'dart:convert';

Schedule scheduleFromJson(String str) => Schedule.fromMap(json.decode(str));

String scheduleToJson(Schedule data) => json.encode(data.toMap());

class Schedule {
  String name;
  String id;

  Schedule({
    this.name,
    this.id,
  });

  factory Schedule.fromMap(Map<String, dynamic> json) => new Schedule(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "id": id,
      };

  String toString() {
    String output = '';
    output += 'Schedule Object: {\n\t';
    output += 'id: $id\n\t';
    output += 'name: $name\n\t';
    output += '}\n';
    return output;
  }
}
