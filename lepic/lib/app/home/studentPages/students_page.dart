import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exp/app/home/reportPages/assessments_of_student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'create_student_page.dart';

class StudentPage extends StatefulWidget {

  const StudentPage({ Key? key ,this.classId}) : super(key: key);
  final String? classId;

  static Future<void> show(BuildContext context, String classId) async {

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StudentPage(classId: classId,),
        fullscreenDialog: true,
      ),
    );
  }
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Students',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        actions: <Widget>[
          FloatingActionButton(
              onPressed: () => CreateStudentPage.show(context),
              heroTag: 'add',
              child: Icon(Icons.add)),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
  String id =FirebaseAuth.instance.currentUser!.uid;
  final reference = FirebaseFirestore.instance.collection('students').where('classId', isEqualTo: widget.classId);
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
              title: Text(data['studentFirstName']+' '+data['studentLastName']),
              subtitle: Text(data['studentClass']),
              isThreeLine: true,
              onTap: () => StudentAssessmentsPage.show(context,data['studentId'].toString()),
            );
          }).toList(),
        );
      },
    );


  }


}
