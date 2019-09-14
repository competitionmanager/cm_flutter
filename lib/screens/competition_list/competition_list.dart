import 'package:cm_flutter/screens/competition_list/competition_search.dart';
import 'package:cm_flutter/test_options_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CompetitionList extends StatefulWidget {
  @override
  _CompetitionListState createState() => _CompetitionListState();
}

class _CompetitionListState extends State<CompetitionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Competitions',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
        elevation: 1.0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CompetitionSearch(),
              );
            },
          )
        ],
      ),
      drawer: TestOptionsDrawer(),
      body: Container(),
    );
  }
}
