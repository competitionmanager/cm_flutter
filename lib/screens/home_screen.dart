import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/auth/auth_provider.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/create_competition.dart';
import 'package:cm_flutter/screens/competition_list/competition_search.dart';
import 'package:cm_flutter/widgets/competition_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseUser user;

  HomeScreen({this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirestoreProvider db;
  AuthProvider auth;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
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
                  builder: (BuildContext context) =>
                      CreateCompetitionScreen(widget.user));
              Navigator.of(context).push(route);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildTopBar(),
              SizedBox(height: 16.0),
              Text(
                'Saved Competitions',
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 16.0),
              widget.user != null ? buildStreamBuilder() : Container()
              // buildSavedCompetitionList(),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> buildStreamBuilder() {
    return StreamBuilder(
      stream: db.getSavedCompetitions(widget.user.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              Competition comp = Competition.fromMap(
                snapshot.data.documents[index].data,
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: CompetitionCard(
                  competition: comp,
                  user: widget.user,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Row buildTopBar() {
    return Row(
      children: <Widget>[
        buildSearchBar(),
        SizedBox(width: 8.0),
        CircleAvatar(
          radius: 25,
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.07),
        )
      ],
    );
  }

  Expanded buildSearchBar() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showSearch(
            context: context,
            delegate: CompetitionSearch(widget.user),
          );
        },
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.07),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
