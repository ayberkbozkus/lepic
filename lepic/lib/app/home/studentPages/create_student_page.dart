

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exp/app/home/model/class.dart';
import 'package:exp/app/home/model/student.dart';
import 'package:exp/services/api_path.dart';
import 'package:exp/services/auth.dart';
import 'package:exp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
String classId = '';
class CreateStudentPage extends StatefulWidget {
  //const CreateStudentPage({ Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) async {

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateStudentPage(),
        fullscreenDialog: true,
      ),
    );
  }
  @override
  _CreateStudentPageState createState() => _CreateStudentPageState();
}

class _CreateStudentPageState extends State<CreateStudentPage> {


  var _className ;
  var setDefaultMake = true;
  final TextEditingController _firstname_controller = TextEditingController();
  final TextEditingController _lastname_controller = TextEditingController();
  String get _studentFirstName => _firstname_controller.text;
  String get _studentLastName => _lastname_controller.text;

  
  Future<void> _saveStudent() async {
    String id =FirebaseAuth.instance.currentUser!.uid;
    final stuId = Uuid().v4();
    final reference = FirebaseFirestore.instance.collection(ApiPath.allClasses(id)).where('className', isEqualTo: _className);
    await reference.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        classId = doc["classId"];
      });
    });
    final newStudent = Students(studentId: stuId, classId: classId ,
        studentFirstName: _studentFirstName,
      studentLastName: _studentLastName,
      studentClass: _className);
    await FirestoreDatabase(uid: FirebaseAuth.instance.currentUser!.uid).createStudent(newStudent);
    Navigator.of(context).pop();

  }

  @override
  Widget build(BuildContext context) {
    String uid = Auth().currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('New Student'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed:() => _saveStudent(),
          ),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _firstname_controller,
            decoration: InputDecoration(labelText: 'Student First Name'),
          ),
          TextFormField(
            controller: _lastname_controller,
            decoration: InputDecoration(labelText: 'Student Last Name'),
          ),
          SizedBox(height: 8.0),
          Expanded(
            flex: 1,
            //child: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users/$uid/classes')
              .orderBy('className')
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
                  _className = snapshot.data!.docs[0].get('className');
                  debugPrint('setDefault make: $_className');

                }
                return DropdownButton(
                  isExpanded: false,
                  value: _className,
                  items: snapshot.data!.docs.map((value) {
                    return DropdownMenuItem(
                      value: value.get('className'),
                      child: Text('${value.get('className')}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    debugPrint('selected onchange: $value');
                    setState(
                          () {
                        debugPrint('make selected: $value');
                        // Selected value will be stored
                        _className = value;

                        // Default dropdown value won't be displayed anymore
                        setDefaultMake = false;
                      },
                    );
                  },
                );
              },
            ),
            //),
          ),

        ],
      ),
    );
  }
}
