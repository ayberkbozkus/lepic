import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exp/app/home/assessmentPages/create_assessment_page.dart';
import 'package:exp/app/home/assessmentPages/record_audio_page.dart';
import 'package:exp/app/home/assessmentPages/start_assess.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AssessmentPage extends StatefulWidget {

  const AssessmentPage({ Key? key }) : super(key: key);


  static Future<void> show(BuildContext context, String classId) async {

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AssessmentPage(),
        fullscreenDialog: true,
      ),
    );
  }
  @override
  _AssessmentPageState createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assessments',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        actions: <Widget>[
          FloatingActionButton(
              onPressed: () => CreateAssessmentPage.show(context),
              heroTag: 'add',
              child: Icon(Icons.add)),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    String id =FirebaseAuth.instance.currentUser!.uid;
    final reference = FirebaseFirestore.instance.collection('assessments');
    return StreamBuilder<QuerySnapshot>(
      stream: reference.get().asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['assessmentName']),
              subtitle: Text(data['className']),
              isThreeLine: true,
              onTap: () => StartAssessPage.show(context, data['assessId'].toString(),data['classId'].toString()),
              //onTap: () => print(data['assessId'].toString()),


            );
          }).toList(),
        );
      },
    );
  }


}
