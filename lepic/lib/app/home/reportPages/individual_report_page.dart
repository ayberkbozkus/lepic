import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exp/app/home/assessmentPages/record_audio_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class IndividualReportPage extends StatefulWidget {

  const IndividualReportPage({Key? key, required this.resultId, required this.studentId }) : super(key: key);
  final String resultId;
  final String studentId;

  static Future<void> show(BuildContext context, String resultId, String studentId) async {

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IndividualReportPage(resultId: resultId,studentId:studentId),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _IndividualReportPageState createState() =>
      _IndividualReportPageState();
}

class _IndividualReportPageState extends State<IndividualReportPage> {
  String firstName = '';
  String lastName = '';
  String fullName = '';
  String date = '';
  String totalReadingTime = '';
  String assessmentName ='';
  String assessId ='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Individual Report',
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
  Future<void> getStudentName() async{
    String stuId = widget.studentId;
    final reference = FirebaseFirestore.instance.doc('students/$stuId');
    await reference.get().then((snapshot) =>
    firstName = snapshot.data()!["studentFirstName"].toString()
    );
    await reference.get().then((snapshot) =>
    lastName = snapshot.data()!["studentLastName"].toString()
    );
    fullName = firstName + lastName;
    String resultId = widget.resultId;

    final ref2 = FirebaseFirestore.instance.doc('results/$resultId');
    await ref2.get().then((snapshot) =>
    date = snapshot.data()!["date"].toString()
    );
    await ref2.get().then((snapshot) =>
    totalReadingTime = snapshot.data()!["totalReadingTime"].toString()
    );
    await ref2.get().then((snapshot) =>
    assessId = snapshot.data()!["assessId"].toString()
    );
    final ref3 = FirebaseFirestore.instance.doc('assessments/$assessId');
    await ref3.get().then((snapshot) =>
    assessmentName = snapshot.data()!["assessmentName"].toString()
    );
  }

  Widget _buildContents(BuildContext context) {

    return FutureBuilder(
          future: getStudentName(),
          builder: (context,snapshot) {
            return Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  height: 100,
                  width: 350,
                  padding: EdgeInsets.all(10),
                  color: Colors.blue[200],
                  child: Text(
                      'The student $fullName had his/her reading fluency assessed in $date. He/She read the text $assessmentName in $totalReadingTime seconds.',
                      style: TextStyle(fontSize: 12)
                  ),
                ),
                SizedBox(height: 10,),
              ],
            );
          },


        );

  }

}