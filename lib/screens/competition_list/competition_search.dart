import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/view_competition_screen.dart';
import 'package:flutter/material.dart';

class CompetitionSearch extends SearchDelegate<String> {
  FirestoreProvider db;

  CompetitionSearch() {
    db = FirestoreProvider();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for app bar
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {})];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show some result based on the selection
    return Center(
        child: Text(query)
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show when someone searches for something
    return StreamBuilder(
      stream: db.getCompetitions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        List<Competition> comps = new List();
        for (DocumentSnapshot doc in snapshot.data.documents) {
          Competition comp = Competition.fromMap(doc.data);
          if (comp.name.startsWith(query)) {
            comps.add(comp);
          }
        }
        comps.sort((c1, c2) => c2.date.compareTo(c1.date));
        /*
        */
        return ListView.builder(
          itemCount: comps.length,
          itemBuilder: (context, index) {
            return _buildItem(context, comps[index]);
          }
        );
      },
    );
  }

  ListTile _buildItem(BuildContext context, Competition comp) {
    // Construct a row with the competition name.
    return ListTile(
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => ViewCompetitionScreen(compId: comp.id),
        );
        Navigator.of(context).push(route);
      },
      leading: Icon(Icons.event),
      title: RichText(
          text: TextSpan(
        text: comp.name.substring(0, query.length),
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
              text: comp.name.substring(query.length),
              style: TextStyle(color: Colors.grey))
        ],
      )),
    );
  }
}
