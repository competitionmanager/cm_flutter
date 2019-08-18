import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirestoreProvider {
  Firestore firestore = Firestore.instance;
  Uuid uuid = Uuid();

  Stream<QuerySnapshot> getTeams() {
    return firestore.collection('teams').snapshots();
  }

  Stream<DocumentSnapshot> getTeam(String teamId) {
    return firestore.collection('teams').document(teamId).snapshots();
  }

  void updateTeam(String teamId, Map<String, dynamic> data) {
    firestore.collection('teams').document(teamId).updateData(data);
  }

  void deleteTeam(String teamId) {
    firestore.collection('teams').document(teamId).delete();
  }

  String addTeam(String name) {
    CollectionReference teamsRef = firestore.collection('teams');
    String id = uuid.v4();
    teamsRef.document(id).setData({
      'name': name,
      'bio': 'Make your bio special!',
      'id': id,
    });
    return id;
  }

  void addTeams() {
    CollectionReference teamsRef = firestore.collection('teams');

    String id = uuid.v4();
    teamsRef.document(id).setData({
      'name': 'Project D',
      'bio': 'The Best team in the world.',
      'id': id,
    });
    id = uuid.v4();
    teamsRef.document(id).setData({
      'name': 'Wannabes',
      'bio': 'We\'re the bees!!',
      'id': id,
    });
    id = uuid.v4();
    teamsRef.document(id).setData({
      'name': 'THEM',
      'bio': 'The worst team in the world.',
      'id': id,
    });
    id = uuid.v4();
    teamsRef.document(id).setData({
      'name': 'ARC',
      'bio': 'A Rhythm Company',
      'id': id,
    });
    id = uuid.v4();
    teamsRef.document(id).setData({
      'name': 'Stuy Legacy',
      'bio': 'We\'re the youngins',
      'id': id,
    });
  }

  Stream<DocumentSnapshot> getCompetition(String compId) {
    return firestore.collection('competitions').document(compId).snapshots();
  }

  Stream<QuerySnapshot> getCompetitions() {
    return firestore.collection('competitions').snapshots();
  }

  void updateCompetition(String compId, Map<String, dynamic> data) {
    firestore.collection('competitions').document(compId).updateData(data);
  }

  void deleteCompetition(String compId) {
    firestore.collection('competitions').document(compId).delete();
  }

  String addCompetition(String name, String organizer, String location) {
    CollectionReference teamsRef = firestore.collection('competitions');
    String id = uuid.v4();
    teamsRef.document(id).setData({
      'id': id,
      'name': name,
      'organizer': organizer,
      'location': location,
    });
    return id;
  }

  void addDummyCompetition() {
    CollectionReference compsRef = firestore.collection('competitions');

    String id = uuid.v4();
    compsRef.document(id).setData({
      'id': id,
      'name': 'Prelude East Coast 2019',
      'organizer': 'Project D Dance Company',
      'description':
          'Prelude EC, hosted by Project D, is one of the biggest dance competitions in the NY/NJ dance community.',
      'date': 'Sat, December 10th, 2019',
      'location': 'Sacaucus, New Jersey',
    });
    id = uuid.v4();
    compsRef.document(id).setData({
      'id': id,
      'name': 'Reign or Shine 2019',
      'organizer': 'NJIT ',
      'description':
          'Prelude EC, hosted by Project D, is one of the biggest dance competitions in the NY/NJ dance community.',
      'date': 'Sat, December 10th, 2019',
      'location': 'Sacaucus, New Jersey',
    });
  }

  Stream<QuerySnapshot> getEvents(String compId) {
    return firestore
        .collection('competitions')
        .document(compId)
        .collection('events').orderBy('startTime')
        .snapshots();
  }

  String addEvent(String compId, String name, DateTime startTime, DateTime endTime) {
    CollectionReference compEventsRef = firestore
        .collection('competitions')
        .document(compId)
        .collection('events');
    String id = uuid.v4();
    compEventsRef.document(id).setData({
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
      'id': id,
    });
    return id;
  }

  void addDummyEvents(String compId) {
    CollectionReference compEventsRef = firestore
        .collection('competitions')
        .document(compId)
        .collection('events');

    String id = uuid.v4();
    DateTime startTime = DateTime.now().subtract(Duration(hours: 7));
    DateTime endTime = startTime.add(Duration(minutes: 8));
    compEventsRef.document(id).setData({
      'name': 'Unique Movement Tech',
      'startTime': startTime,
      'endTime': endTime,
      'id': id,
    });

    id = uuid.v4();
    startTime = endTime.add(Duration(minutes: 1));
    endTime = startTime.add(Duration(minutes: 8));
    compEventsRef.document(id).setData({
      'name': 'Wannabes Tech',
      'startTime': startTime,
      'endTime': endTime,
      'id': id,
    });

    id = uuid.v4();
    startTime = endTime.add(Duration(minutes: 1));
    endTime = startTime.add(Duration(minutes: 8));
    compEventsRef.document(id).setData({
      'name': 'N/A Tech',
      'startTime': startTime,
      'endTime': endTime,
      'id': id,
    });
    id = uuid.v4();
    startTime = endTime.add(Duration(minutes: 1));
    endTime = startTime.add(Duration(minutes: 8));
    compEventsRef.document(id).setData({
      'name': 'Choreo Cookies Tech',
      'startTime': startTime,
      'endTime': endTime,
      'id': id,
    });
    id = uuid.v4();
    startTime = endTime.add(Duration(minutes: 1));
    endTime = startTime.add(Duration(minutes: 8));
    compEventsRef.document(id).setData({
      'name': 'GRV Tech',
      'startTime': startTime,
      'endTime': endTime,
      'id': id,
    });
    id = uuid.v4();
    startTime = endTime.add(Duration(minutes: 1));
    endTime = startTime.add(Duration(minutes: 8));
    compEventsRef.document(id).setData({
      'name': 'The Company Tech',
      'startTime': startTime,
      'endTime': endTime,
      'id': id,
    });
  }

  void clearEvents(String compId) {
    CollectionReference compEventsRef = firestore
        .collection('competitions')
        .document(compId)
        .collection('events');
  }

  void deleteEvent(String compId, String eventId) {
    firestore
        .collection('competitions')
        .document(compId)
        .collection('events')
        .document(eventId)
        .delete();
  }

  void addNewUser(FirebaseUser user) {
    DocumentReference userRef =
        firestore.collection('users').document(user.uid);
    userRef.setData({
      'id': user.uid,
      'name': user.displayName,
      'email': user.email,
    });
  }

  Future saveDeviceToken(String fcmToken) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    DocumentReference tokenRef =
        firestore.collection('users').document(user.uid);

    tokenRef
        .updateData({'token': fcmToken, 'platform': Platform.operatingSystem});
  }
}
