import 'package:flutter/material.dart';

class ColorGradientButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  ColorGradientButton({this.text, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        onPressed: onPressed,
      ),
    );
  }
}
