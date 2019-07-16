import 'package:cm_flutter/test_options_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;


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
    CollectionReference teamsRef = db.collection('teams');
    teamsRef.document('projectd123123').setData({
      'name': 'Project D',
      'bio': 'The Best team in the world.'
    });
    teamsRef.document('wannabes123123').setData({
      'name': 'Wannabes',
      'bio': 'We\'re the bees!!'
    });
    teamsRef.document('them123').setData({
      'name': 'THEM',
      'bio': 'The worst team in the world.'
    });
    teamsRef.document('arc123').setData({
      'name': 'ARC', 
      'bio': 'A Rhythm Company'
    });
    teamsRef.document('stuy123').setData({
      'name': 'Stuy Legacy',
      'bio': 'We\'re the youngins'
    });
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('teams').document(doc.documentID).delete();
  }

  void printResponse() async {
    String text = 'This is a text from flutter.';
    String url = 'https://us-central1-cmfirebase-17373.cloudfunctions.net/addMessage?text=$text';

    final response = await http.get(Uri.parse(url));
    print(response.body);
    print(response.statusCode);
    print(response.reasonPhrase);
  }
}
