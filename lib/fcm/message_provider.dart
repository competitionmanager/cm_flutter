import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MessageProvider {
  BuildContext context;
  final FirebaseMessaging fcm = FirebaseMessaging();
  
  MessageProvider({this.context}) {
    fcmConfig(context);
  }
  
  Future<String> getToken() async {
    return await fcm.getToken();
  }

  void fcmConfig(BuildContext context) {
    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                //TODO: Send user to a different screen
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
}