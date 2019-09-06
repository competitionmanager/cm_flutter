import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String tabText;
  final bool tabIsSelected;
  final VoidCallback onTabSelected;

  TabItem({this.tabText, this.tabIsSelected, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTabSelected,
      child: Container(
        decoration: tabIsSelected
            ? BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              )
            : BoxDecoration(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Text(
              tabText,
              style: tabIsSelected
                  ? TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)
                  : TextStyle(color: Colors.black45, fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
