import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exp/app/sign_in/sign_in_page.dart';
import 'package:exp/services/api_path.dart';
import 'package:exp/services/auth.dart';
import 'package:exp/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home/classPages/classes_page.dart';
import 'home/home_page.dart';
import 'home/model/class.dart';
import 'home/profilePages/user_info_page.dart';
import 'package:exp/app/home/model/user.dart';
String? userType = '';
class LandingPage extends StatelessWidget{
  const LandingPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override

  Widget build(BuildContext context) {

    return StreamBuilder<User?>(

      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          if (user == null) {
            return SignInPage(
              auth: auth,
            );
          }
          return _buildContents(context, user.uid);
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildContents(BuildContext context, uid) {
    return FutureBuilder(
      future: getUserType(uid),
      builder: (context, snapshot) {
        if(userType != null && userType == 'Teacher')
          {
            return Provider<Database>(
                create: (_) => FirestoreDatabase(uid: uid),
                //child:ClassPage(auth: auth)
                child:HomePage()
            );
          }
        else {
          return Provider<Database>(
              create: (_) => FirestoreDatabase(uid: uid),
              child:UserInfoPage(auth: auth)
              //child:UserInfoPage(auth: auth)
          );
        }
      },
    );
  }

   Future<void> getUserType(String uid) async {
    final reference = FirebaseFirestore.instance.doc(ApiPath.user(uid));
    String? type;
    await reference.get().then((snapshot) =>
    type = snapshot.data()!["userType"].toString()
    );
    userType = type;

  }
}
