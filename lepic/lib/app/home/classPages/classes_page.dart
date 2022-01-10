import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exp/app/home/classPages/class_list_tile.dart';
import 'package:exp/app/home/model/class.dart';
import 'package:exp/app/home/reportPages/comparative_report.dart';
import 'package:exp/app/home/studentPages/students_page.dart';
import 'package:exp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:exp/services/auth.dart';
import 'package:provider/provider.dart';
import 'create_class_page.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Classes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        actions: <Widget>[
          FloatingActionButton(
              onPressed: () => CreateClassPage.show(context),
              heroTag: 'add',
              child: Icon(Icons.add)),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Classes>>(
      stream: database.classesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Classes>? myList = snapshot.data;
          final children = myList
              ?.map((classes) => ClassListTile(
            classes: classes,
            onTap: () => StudentPage.show(context, classes.Id),
            onLongPress: () => ComparativeReportPage(),
            //onTap: () => print(classes.Id),
          ))
              .toList() ??
              [];

          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(child: Text('Some error occurred'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}