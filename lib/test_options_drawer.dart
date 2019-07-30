import 'package:cm_flutter/screens/competition/create_competition.dart';
import 'package:cm_flutter/screens/competition/view_competitions_screen.dart';
import 'package:cm_flutter/screens/team/create_team_screen.dart';
import 'package:cm_flutter/screens/team/view_teams_screen.dart';
import 'package:flutter/material.dart';

class TestOptionsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Database Manipulation',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            ListTile(
              title: Text(
                'Create Teams',
                style: TextStyle(
                  fontSize: 24.0
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (BuildContext context) => CreateTeamScreen()
                );
                Navigator.of(context).pop(route);
                Navigator.of(context).push(route);
              },
            ),
            ListTile(
              title: Text(
                'View Teams',
                style: TextStyle(
                  fontSize: 24.0
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (BuildContext context) => ViewTeamsScreen()
                );
                Navigator.of(context).pop(route);
                Navigator.of(context).push(route);
              },
            ),
            ListTile(
              title: Text(
                'Create a Competition',
                style: TextStyle(
                  fontSize: 24.0
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (BuildContext context) => CreateCompetitionScreen()
                );
                Navigator.of(context).pop(route);
                Navigator.of(context).push(route);
              },
            ),
            ListTile(
              title: Text(
                'View Competitions',
                style: TextStyle(
                  fontSize: 24.0
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                  builder: (BuildContext context) => ViewCompetitionsScreen()
                );
                Navigator.of(context).pop(route);
                Navigator.of(context).push(route);
              },
            ),
          ],
        ),
      ),
    );
  }
}
