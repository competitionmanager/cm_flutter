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
          builder: (context) => buildDialog(message)
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

  Widget buildDialog(Map<String, dynamic> message) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: 180.0,
        height: 150.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                message['notification']['title'],
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                message['notification']['body'],
                style: TextStyle(fontSize: 18.0, color: Color.fromRGBO(0, 0, 0, 0.65)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
