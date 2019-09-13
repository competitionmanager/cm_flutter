import 'package:flutter/material.dart';

class LabelTextField extends StatefulWidget {
  final TextEditingController textController;
  final TextInputType textInputType;
  final String labelText;
  final bool isParagraph;

  LabelTextField({
    @required this.labelText,
    @required this.textController,
    this.textInputType = TextInputType.text,
    this.isParagraph = false,
  });

  @override
  _LabelTextFieldState createState() => _LabelTextFieldState();
}

class _LabelTextFieldState extends State<LabelTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.labelText,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8.0),
        TextField(
          maxLines: widget.isParagraph ? 3 : 1,
          controller: widget.textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black12),
            ),
            suffixIcon: widget.textController.text != ''
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        widget.textController.clear();
                      });
                    },
                  )
                : null,
          ),
          onChanged: (text) {
            // Set state to make clear button visible.
            setState(() {});
          },
        ),
      ],
    );
  }
}
