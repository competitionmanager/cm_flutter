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
                'Reset database',
                style: TextStyle(
                  fontSize: 24.0
                ),
              ),
              onTap: () {
                Route route = MaterialPageRoute(
                  // builder: (BuildContext context) => TestTeamScreen()
                );
                Navigator.of(context).pushReplacement(route);
              },
            ),
          ],
        ),
      ),
    );
  }
}
