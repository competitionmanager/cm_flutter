import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
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

  Stream<DocumentSnapshot> getCompetitionStream(String compId) {
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

  String addCompetition({String name, String organizer, String location, DateTime date, String downloadURL}) {
    CollectionReference teamsRef = firestore.collection('competitions');
    String id = uuid.v4();
    teamsRef.document(id).setData({
      'id': id,
      'name': name,
      'organizer': organizer,
      'location': location,
      'date': date,
      'description': 'Description of the $name',
      'image_url': downloadURL
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

  Stream<QuerySnapshot> getSchedule({String compId, String scheduleId}) {
    return firestore
        .collection('competitions')
        .document(compId)
        .collection('schedules')
        .document(scheduleId)
        .collection('events')
        .orderBy('startTime')
        .snapshots();
  }

  // Adds a schedule to the given competition.
  // Returns the id of the schedule.
  String addSchedule({String compId, String name}) {
    CollectionReference schedulesRef = firestore.collection('competitions').document(compId).collection('schedules');
    String id = uuid.v4();
    schedulesRef.document(id).setData({
      'id': id,
      'name': name,
    });
    return id;
  }

  Stream<QuerySnapshot> getSchedules(String compId) {
    return firestore
        .collection('competitions')
        .document(compId)
        .collection('schedules')
        .snapshots();
  }


  void deleteSchedule({String compId, String scheduleId}) {

    firestore
        .collection('competitions')
        .document(compId)
        .collection('schedules')
        .document(scheduleId)
        .delete();
  }

  String addEvent(String compId, String scheduleId, String name,
      DateTime startTime, DateTime endTime) {
    CollectionReference compEventsRef = firestore
        .collection('competitions')
        .document(compId)
        .collection('schedules')
        .document(scheduleId)
        .collection('events');
    String id = uuid.v4();
    compEventsRef.document(id).setData({
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
      'id': id,
      'subscribers': [],
      'description': '',
    });
    return id;
  }

  void addEvents(
      {String compId,
      String scheduleId,
      DateTime startTime,
      int numTeams,
      int eventDuration,
      int breakDuration}) {
    String id = uuid.v4();

    CollectionReference compEventsRef = firestore
        .collection('competitions')
        .document(compId)
        .collection('schedules')
        .document(scheduleId)
        .collection('events');

    DateTime eventStartTime = startTime;
    for (int i = 0; i < numTeams; i++) {
      id = uuid.v4();
      compEventsRef.document(id).setData({
        'name': '',
        'startTime': eventStartTime,
        'endTime': eventStartTime.add(Duration(minutes: eventDuration)),
        'id': id,
        'subscribers': []
      });
      eventStartTime = eventStartTime.add(Duration(minutes: eventDuration));
      eventStartTime = eventStartTime.add(Duration(minutes: breakDuration));
    }
  }

  void updateEvent(String compId, String scheduleId, String eventId,
      String name, DateTime startTime, DateTime endTime, String description) {
    CollectionReference compEventsRef = firestore
        .collection('competitions')
        .document(compId)
        .collection('schedules')
        .document(scheduleId)
        .collection('events');
    compEventsRef.document(eventId).updateData({
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
    });
  }

  void deleteEvent(String compId, String scheduleId, String eventId) {
    firestore
        .collection('competitions')
        .document(compId)
        .collection('schedules')
        .document(scheduleId)
        .collection('events')
        .document(eventId)
        .delete();
  }

  void addSubscriber(
      String compId, String scheduleId, String eventId, FirebaseUser user) {
    DocumentReference eventRef = firestore
        .collection('competitions')
        .document(compId)
        .collection('schedules')
        .document(scheduleId)
        .collection('events')
        .document(eventId);
    eventRef.updateData({
      'subscribers': FieldValue.arrayUnion([user.uid])
    });
  }

  void removeSubscriber(
      String compId, String scheduleId, String eventId, FirebaseUser user) {
    DocumentReference eventRef = firestore
        .collection('competitions')
        .document(compId)
        .collection('schedules')
        .document(scheduleId)
        .collection('events')
        .document(eventId);
    eventRef.updateData({
      // TODO: What happens if user does not exist in the array?
      'subscribers': FieldValue.arrayRemove([user.uid])
    });
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
