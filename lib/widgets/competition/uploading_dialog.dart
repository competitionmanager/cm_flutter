import 'package:cm_flutter/styles/colors.dart';
import 'package:flutter/material.dart';

class UploadingDialog extends StatefulWidget {
  @override
  _UploadingDialogState createState() => _UploadingDialogState();
}

class _UploadingDialogState extends State<UploadingDialog> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.6,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ),
        Center(
          child: Container(
            height: 160.0,
            width: 160.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Uploading',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(kMintyGreen),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
