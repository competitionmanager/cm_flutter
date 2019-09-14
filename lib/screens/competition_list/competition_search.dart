import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/view_competition_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompetitionSearch extends SearchDelegate<String> {
  final FirebaseUser user;
  FirestoreProvider db;

  CompetitionSearch(this.user) {
    db = FirestoreProvider();
  }

  // @override
  // ThemeData appBarTheme(BuildContext context) {
  //   final ThemeData theme = Theme.of(context).copyWith(
  //     appBarTheme: AppBarTheme(
  //       color: Colors.white,
  //       elevation: 0.0,
  //     ),
  //   );
  //   return theme;
  // }

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the app bar
    return BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show some result based on the selection
    return Center(child: Text(query));
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

          if (comp.name.toLowerCase().startsWith(query.toLowerCase())) {
            comps.add(comp);
          }
        }

        return ListView.builder(
          itemCount: comps.length,
          itemBuilder: (context, index) {
            return buildItem(
              context,
              comps[index],
            );
          },
        );
      },
    );
  }

  ListTile buildItem(BuildContext context, Competition comp) {
    // Construct a row with the competition name.
    return ListTile(
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => ViewCompetitionScreen(comp, user),
        );
        Navigator.of(context).push(route);
      },
      title: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: comp.name.substring(0, query.length),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: comp.name.substring(query.length),
            )
          ],
        ),
      ),
      subtitle: Text(DateFormat('EEE, MMMM d, yyyy').format(comp.date)),
    );
  }
}
