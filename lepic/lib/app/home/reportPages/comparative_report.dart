import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exp/app/home/assessmentPages/record_audio_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ComparativeReportPage extends StatefulWidget {

  const ComparativeReportPage({Key? key, this.assessId,this.classId }) : super(key: key);
  final String? classId;
  final String? assessId;
  static Future<void> show(BuildContext context, String assessId, String classId) async {

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ComparativeReportPage(assessId: assessId,classId: classId,),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _ComparativeReportPageState createState() =>
      _ComparativeReportPageState();
}

class _ComparativeReportPageState extends State<ComparativeReportPage> {

  var _studentId ;
  var setDefaultMake = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Student',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        actions: <Widget>[
          TextButton(
            onPressed: () => AudioPage.show(context, _studentId.toString(), widget.assessId.toString()),
            //onPressed: () => print( widget.assessId.toString()),
            child: Text('Start'),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          ),
        ],

      ),
      body: SingleChildScrollView(

        reverse: true,
        child: Container(
            child: Column(
                children: <Widget>[
                  Text("Please Select a Student to Assess Reading Fluency",
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 20.0,),),
                  SizedBox(height: 8.0),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('students').where('classId', isEqualTo: widget.classId)
                    //.orderBy('studentId')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      // Safety check to ensure that snapshot contains data
                      // without this safety check, StreamBuilder dirty state warnings will be thrown
                      if (!snapshot.hasData) return Container();
                      // Set this value for default,
                      // setDefault will change if an item was selected
                      // First item from the List will be displayed
                      if (setDefaultMake) {
                        _studentId = snapshot.data!.docs[0].get('studentId');
                      }
                      return DropdownButton(
                        isExpanded: false,
                        value: _studentId,
                        items: snapshot.data!.docs.map((value) {
                          return DropdownMenuItem(
                            value: value.get('studentId'),
                            child: Text('${value.get('studentId')}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          debugPrint('selected onchange: $value');
                          setState(
                                () {
                              debugPrint('make selected: $value');
                              // Selected value will be stored
                              _studentId = value;

                              // Default dropdown value won't be displayed anymore
                              setDefaultMake = false;
                            },
                          );
                        },
                      );
                    },
                  ),
                ])
        ),


      ),
    );
  }
}