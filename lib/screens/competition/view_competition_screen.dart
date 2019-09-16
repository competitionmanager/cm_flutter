import 'package:cm_flutter/fcm/message_provider.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/edit_competition_screen.dart';
import 'package:cm_flutter/screens/competition/schedule/view_schedule_screen.dart';
import 'package:cm_flutter/styles/colors.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewCompetitionScreen extends StatefulWidget {
  final Competition competition;
  final FirebaseUser user;

  ViewCompetitionScreen(this.competition, this.user);

  @override
  _ViewCompetitionScreenState createState() => _ViewCompetitionScreenState();
}

class _ViewCompetitionScreenState extends State<ViewCompetitionScreen> {
  Competition competition;
  FirestoreProvider db;
  MessageProvider messageProvider;
  bool isSaved = false;
  String formattedDate;

  @override
  void initState() {
    super.initState();
    competition = widget.competition;
    db = FirestoreProvider();
    // Allows alert dialogs to show up when notification received.
    messageProvider = MessageProvider(context: context);

    setState(() {
      isSaved = widget.competition.savedUsers.contains(widget.user.uid);
    });

    formattedDate =
        DateFormat('EEE, MMMM d, yyyy').format(widget.competition.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: db.getCompetitionStream(competition.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              competition = Competition.fromMap(snapshot.data.data);
            }
            return Stack(
              children: <Widget>[buildScreen(context), buildAppBar(context)],
            );
          },
        ),
      ),
    );
  }

  Widget buildScreen(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              buildPhotoContainer(context),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      competition.name,
                      style: TextStyle(
                          fontSize: 32.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12.0),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 18.0, color: Colors.black54),
                        children: <TextSpan>[
                          TextSpan(text: 'Hosted by '),
                          TextSpan(
                            text: widget.competition.organizer,
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.date_range,
                          color: Colors.black54,
                          size: 28.0,
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          color: Colors.black54,
                          size: 28.0,
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          competition.location,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(color: Colors.black26),
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 8.0,
          ),
          child: ColorGradientButton(
            color: kMintyGreen,
            text: 'View Schedule',
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (BuildContext context) => ViewScheduleScreen(
                  competition: competition,
                  user: widget.user,
                ),
              );
              Navigator.of(context).push(route);
            },
          ),
        ),
      ],
    );
  }

  Row buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BackButton(
          color: Colors.white,
        ),
        Row(
          children: <Widget>[
            Visibility(
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  Route route = MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EditCompetitionScreen(competition: competition),
                  );
                  Navigator.of(context).push(route);
                },
              ),
              visible: competition.admins.contains(widget.user.uid),
            ),
            isSaved
                ? IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      db.unsaveCompetition(competition, widget.user.uid);
                      setState(() {
                        isSaved = false;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      db.saveCompetition(competition, widget.user.uid);
                      setState(() {
                        isSaved = true;
                      });
                    },
                  ),
          ],
        )
      ],
    );
  }

  Container buildPhotoContainer(BuildContext context) {
    if (competition.imageUrl == null) {
      // If image_url has not loaded yet
      return Container(
        height: MediaQuery.of(context).size.height / 3,
        color: Colors.black26,
      );
    } else if (competition.imageUrl == '') {
      // If image_url is empty
      return Container(
        height: MediaQuery.of(context).size.height / 3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Colors.blue[400],
              Colors.indigo[800],
            ],
          ),
        ),
      );
    } else {
      // If image_url exists
      return Container(
        color: Colors.black26,
        height: MediaQuery.of(context).size.height / 3,
        // Get image from Firebase Storage
        child: Hero(
          tag: widget.competition.id,
          child: Image.network(competition.imageUrl, fit: BoxFit.cover),
        ),
      );
    }
  }
}
