import 'package:cm_flutter/styles/colors.dart';
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
                color: kMintyGreen,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Text(
              tabText,
              style: tabIsSelected
                  ? TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    )
                  : TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
