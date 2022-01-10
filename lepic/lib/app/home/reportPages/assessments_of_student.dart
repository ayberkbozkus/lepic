import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exp/app/home/assessmentPages/record_audio_page.dart';
import 'package:exp/app/home/reportPages/individual_report_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class StudentAssessmentsPage extends StatefulWidget {

  const StudentAssessmentsPage({Key? key, this.studentId, }) : super(key: key);
  final String? studentId;

  static Future<void> show(BuildContext context, String studentId) async {

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StudentAssessmentsPage(studentId: studentId,),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _StudentAssessmentsPageState createState() =>
      _StudentAssessmentsPageState();
}

class _StudentAssessmentsPageState extends State<StudentAssessmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assessment Results of the Student',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: _buildContents(context),
    );
  }
  Widget _buildContents(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('results').where('stuId', isEqualTo: widget.studentId)
      //.orderBy('studentId')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
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
              title: Text(data['resultId']),
              subtitle: Text(data['date']),
              isThreeLine: true,
              onTap: () => IndividualReportPage.show(context,data['resultId'].toString(),data['stuId'].toString()),
            );
          }).toList(),
        );
      },
    );
  }
}