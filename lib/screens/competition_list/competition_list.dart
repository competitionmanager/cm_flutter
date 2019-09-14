import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/create_competition.dart';
import 'package:cm_flutter/screens/competition/view_competition_screen.dart';
import 'package:cm_flutter/screens/competition_list/competition_search.dart';
import 'package:cm_flutter/test_options_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CompetitionList extends StatefulWidget {
  @override
  _CompetitionListState createState() => _CompetitionListState();
}

class _CompetitionListState extends State<CompetitionList> {
  final FirestoreProvider db = FirestoreProvider();
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    initUserInfo();
  }

  void initUserInfo() async {
    // ! TODO: Pass user information into this widget.
    // ! We might want to render the screen differently depending on the user permission / competition privacy settings.
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await auth.currentUser();
    print(currentUser);
    setState(() {
      this.user = currentUser;
    });
  }

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
                  builder: (BuildContext context) => CreateCompetitionScreen(this.user));
              Navigator.of(context).push(route);
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CompetitionSearch(this.user),
              );
            },
          ),
        ],
      ),
      drawer: TestOptionsDrawer(),
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
          visible: comp.admins.contains(this.user.uid)),
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) => ViewCompetitionScreen(comp, this.user),
        );
        Navigator.of(context).push(route);
      },
    );
  }
}
