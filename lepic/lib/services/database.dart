
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exp/app/home/model/assessment.dart';
import 'package:exp/app/home/model/class.dart';
import 'package:exp/app/home/model/results.dart';
import 'package:exp/app/home/model/student.dart';
import 'package:exp/app/home/model/user.dart';
import 'package:exp/services/api_path.dart';


import 'firestore_service.dart';
abstract class Database{
  Future<void> addClass(Classes classes);
  void readClass();
  Stream<List<Classes>> classesStream();
  Future<void> createUser(Users user);
  Future<void> createClass(Classes classes);
  Future<void> createStudent(Students student);
}
// in order to create uniqe document id
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
class FirestoreDatabase implements Database{
  FirestoreDatabase ({required this.uid}) : assert(uid != null);
  final String uid;
  final _FsService = FirestoreService.instance;

  Future<void> createStudent(Students student) async {
    try {
      final stuId = student.studentId;
      print(stuId);
      final reference = FirebaseFirestore.instance.doc("students/$stuId");
      final cId = student.classId;
      await reference.set({
        'studentFirstName': student.studentFirstName,
        'studentLastName': student.studentLastName,
        'studentClass': student.studentClass,
        'classId': student.classId,
        'studentId': student.studentId,
      });
      final classRef = FirebaseFirestore.instance.doc("users/$uid/classes/$cId");
      await classRef.set({'studentList': FieldValue.arrayUnion([student.studentId])},SetOptions(merge: true));

    } catch (e) {
      print(e);
    }
  }
  Future<void> createAssess(Assessment assessment) async {
    try {
      final assessId = assessment.assessId;
      final reference = FirebaseFirestore.instance.doc("assessments/$assessId");
      final cId = assessment.classId;
      await reference.set({
        'assessmentName': assessment.assessmentName,
        'className': assessment.className,
        'assessId': assessment.assessId,
        'classId': assessment.classId,
        'text': assessment.text,
      });
      final classRef = FirebaseFirestore.instance.doc("users/$uid/classes/$cId");
      await classRef.set({'assessList': FieldValue.arrayUnion([assessment.assessId])},SetOptions(merge: true));

    } catch (e) {
      print(e);
    }
  }
  Future<void> createResult(Results results) async {
    try {
      final resultId = results.resultId;
      final assessId = results.assessId;
      final stuId = results.studentId;
      print(assessId);
      final reference = FirebaseFirestore.instance.doc("results/$resultId");
      await reference.set({
        'resultId': resultId,
        'assessId': assessId,
        'stuId': stuId,
        'numOfWordsReadFM': results.numOfWordsReadFM,
        'date': results.date,
        'numOfWordsReadPM': results.numOfWordsReadPM,
        'totalReadingTime': results.totalReadingTime,
        'numOfCorrectWordsReadPM': results.numOfCorrectWordsReadPM,
        'numOfIncorrectWords': results.numOfIncorrectWords,
      });
    } catch (e) {
      print(e);
    }
  }
  Future<void> createUser(Users user) async {
    try {
      final reference = FirebaseFirestore.instance.doc("users/$uid");
      await reference.set({
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'userType':user.userType,
        'userId': uid,
      });
    } catch (e) {
      print(e);
    }
  }
  Future<void> createClass(Classes classes) async {
    try {
      final reference = FirebaseFirestore.instance.doc(ApiPath.classes(uid,classes.Id));
      await reference.set({
        'className': classes.className,
        'classLevel': classes.classLevel,
        'classId': classes.Id,
        'creatorName':classes.creatorName,
        'studentList': classes.studentList,
        'assessList' : classes.assesList,
      });
    } catch (e) {
      print(e);
    }
  }


  Future<void> addClass(Classes classes) => _FsService.setData(
    path: ApiPath.classes(uid,documentIdFromCurrentDate()),
    data:classes.toMap(),
  );
  void readClass(){
    final path = ApiPath.allClasses(uid);
    final ref = FirebaseFirestore.instance.collection(path);
    final snapshots = ref.snapshots();
    snapshots.listen((snapshot) {
      snapshot.docs.forEach((snapshot) =>
        print(snapshot.data()));
    });
  }
  Stream<List<Classes>> classesStream() => _FsService.collectionStream(
    path: ApiPath.allClasses(uid),
    builder: (data, documentId) => Classes.fromMap(data, documentId),
  );


  Future<void> _setData({required String path, required Map<String, dynamic> data}) async {
    final documentRef = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await documentRef.set(data);
  }
}