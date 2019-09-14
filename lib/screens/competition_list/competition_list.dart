import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/auth/auth_provider.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/create_competition.dart';
import 'package:cm_flutter/screens/competition/view_competition_screen.dart';
import 'package:cm_flutter/screens/competition_list/competition_search.dart';
import 'package:cm_flutter/screens/login/login_screen.dart';
import 'package:cm_flutter/test_options_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum PopupEnum {
  logout,
}

class CompetitionList extends StatefulWidget {
  final FirebaseUser user;

  CompetitionList(this.user);

  @override
  _CompetitionListState createState() => _CompetitionListState();
}

class _CompetitionListState extends State<CompetitionList> {
  final FirestoreProvider db = FirestoreProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Competitions',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
        elevation: 1.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Route route = MaterialPageRoute(
                  builder: (BuildContext context) =>
                      CreateCompetitionScreen(widget.user));
              Navigator.of(context).push(route);
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CompetitionSearch(widget.user),
              );
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry<PopupEnum>>[
              new PopupMenuItem<PopupEnum>(
                  child: const Text('Logout'), value: PopupEnum.logout),
            ],
            offset: Offset(5, 45),
            onSelected: (PopupEnum choice) async {
              if (choice == PopupEnum.logout) {
                AuthProvider authProvider = AuthProvider();
                authProvider.signOut();
                Route route = MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen());
                Navigator.of(context).pushReplacement(route);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: db.getCompetitions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return buildItem(snapshot.data.documents[index]);
            },
          );
        },
      ),
    );
  }

  ListTile buildItem(DocumentSnapshot doc) {
    Competition comp = Competition.fromMap(doc.data);

    return ListTile(
      title: Text(comp.name),
      subtitle: Text(comp.organizer),
      trailing: Visibility(
          child: IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.black,
            ),
            onPressed: () {
              db.deleteCompetition(comp.id);
            },
          ),
          visible: comp.admins.contains(widget.user.uid)),
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) =>
              ViewCompetitionScreen(comp, widget.user),
        );
        Navigator.of(context).push(route);
      },
    );
  }
}
