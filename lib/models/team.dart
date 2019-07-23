import 'dart:convert';

Team teamFromJson(String str) => Team.fromMap(json.decode(str));

String teamToJson(Team data) => json.encode(data.toMap());

class Team {
    String name;
    String id;
    String bio;

    Team({
        this.name,
        this.id,
        this.bio,
    });

    factory Team.fromMap(Map<String, dynamic> json) => Team(
        name: json["name"],
        id: json["id"],
        bio: json["bio"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "id": id,
        "bio": bio,
    };

    String toString() {
      String output = '';
      output += 'Team Object: {\n\t';
      output += 'name: $name\n\t';
      output += 'bio: $bio\n\t';
      output += 'id: $id\n';
      output += '}\n';
      return output;
    }
}