import 'package:cm_flutter/auth/auth_provider.dart';
import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

enum LoginState { loggedOut, loggedIn }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthProvider authProvider = AuthProvider();
  final FirestoreProvider db = FirestoreProvider();
  final FirebaseMessaging fcm = FirebaseMessaging();
  LoginState loginState = LoginState.loggedOut;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 64.0, bottom: 128.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 64.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Let\'s sign in',
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
                buildGoogleSignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SignInButton buildGoogleSignInButton() {
    return SignInButton(
      Buttons.Google,
      text: "Sign up with Google",
      onPressed: () async {
        if (loginState == LoginState.loggedOut) {
          user = await authProvider.signIn();

          if (user != null) {
            db.addNewUser(user);

            String fcmToken = await fcm.getToken();
            if (fcmToken != null) db.saveDeviceToken(fcmToken);

            Route route = MaterialPageRoute(
                builder: (BuildContext context) => ProfileScreen());
            Navigator.of(context).pushReplacement(route);
          }
        }
      },
    );
  }
}
