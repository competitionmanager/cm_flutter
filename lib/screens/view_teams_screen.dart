import 'package:cm_flutter/test_options_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uuid/uuid.dart';


class ViewTeamsScreen extends StatefulWidget {
  @override
  _ViewTeamsScreenState createState() => _ViewTeamsScreenState();
}

class _ViewTeamsScreenState extends State<ViewTeamsScreen> {
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CM',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
        elevation: 1.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                addData();
                // printResponse();
              },
            ),
          )
        ],
      ),
      drawer: TestOptionsDrawer(),
      body: StreamBuilder(
        stream: db.collection('teams').orderBy('name').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading...');
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
    return ListTile(
      title: Text(doc.data['name']),
      subtitle: Text(doc.data['bio']),
      trailing: IconButton(
        icon: Icon(
          Icons.delete_forever,
          color: Colors.black,
        ),
        onPressed: () {
          deleteData(doc);
        },
      ),
    );
  }

  void addData() {
    Uuid uuid = Uuid();
    CollectionReference teamsRef = db.collection('teams');
    teamsRef.document(uuid.v4()).setData({
      'name': 'Project D',
      'bio': 'The Best team in the world.'
    });
    teamsRef.document(uuid.v4()).setData({
      'name': 'Wannabes',
      'bio': 'We\'re the bees!!'
    });
    teamsRef.document(uuid.v4()).setData({
      'name': 'THEM',
      'bio': 'The worst team in the world.'
    });
    teamsRef.document(uuid.v4()).setData({
      'name': 'ARC', 
      'bio': 'A Rhythm Company'
    });
    teamsRef.document(uuid.v4()).setData({
      'name': 'Stuy Legacy',
      'bio': 'We\'re the youngins'
    });
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('teams').document(doc.documentID).delete();
  }
}
