import 'package:cloud_firestore/cloud_firestore.dart';
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
      'description': 'Prelude EC, hosted by Project D, is one of the biggest dance competitions in the NY/NJ dance community.',
      'date': 'Sat, December 10th, 2019',
      'location': 'Sacaucus, New Jersey',
    });
    id = uuid.v4();
    compsRef.document(id).setData({
      'id': id,
      'name': 'Reign or Shine 2019',
      'organizer': 'NJIT ',
      'description': 'Prelude EC, hosted by Project D, is one of the biggest dance competitions in the NY/NJ dance community.',
      'date': 'Sat, December 10th, 2019',
      'location': 'Sacaucus, New Jersey',
    });
  }
  
}