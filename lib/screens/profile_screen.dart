import 'package:cm_flutter/auth/auth_provider.dart';
import 'package:cm_flutter/fcm/message_provider.dart';
import 'package:cm_flutter/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthProvider authProvider = AuthProvider();
  MessageProvider messageProvider;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    authProvider.getCurrentUser().then((currentUser) {
      setState(() {
        user = currentUser;
      });
    });
    messageProvider = MessageProvider(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Center(
          child: user != null
              ? Padding(
                  padding: const EdgeInsets.all(64.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.displayName,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(
                        height: 64.0,
                      ),
                      RaisedButton(
                        child: Text('Log Out'),
                        onPressed: () {
                          authProvider.signOut();
                          Route route = MaterialPageRoute(
                              builder: (BuildContext context) => LoginScreen());
                          Navigator.of(context).pop(route);
                          Navigator.of(context).push(route);
                        },
                      ),
                    ],
                  ),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
