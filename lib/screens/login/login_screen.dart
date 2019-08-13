import 'package:cm_flutter/auth/auth_provider.dart';
import 'package:cm_flutter/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoginState {
  loggedOut,
  loggedIn,
  loggingIn,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseUser user;
  LoginState loginState = LoginState.loggedOut;
  AuthProvider authProvider = AuthProvider();

  @override
  void initState() {
    super.initState();
    if (user == null) {
      loginState = LoginState.loggedOut;
    } else {
      loginState = LoginState.loggedIn;
    }
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
                loginState == LoginState.loggedOut
                    ? buildGoogleSignInButton()
                    : RaisedButton(
                        child: Text('Log Out'),
                        onPressed: () {
                          authProvider.signOut();
                          setState(
                            () {
                              loginState = LoginState.loggedOut;
                            },
                          );
                        },
                      ),
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
            Route route = MaterialPageRoute(
                builder: (BuildContext context) => ProfileScreen(user: user));
            Navigator.of(context).pop(route);
            Navigator.of(context).push(route);
          }
        }
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: BackButton(),
      title: Text(
        'Login Screen',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
    );
  }
}
