
import 'package:exp/app/home/classPages/classes_page.dart';
import 'package:exp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../landing_page.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      Navigator.pop(context, 'OK');

      await Auth().logOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure that you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _signOut(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(
        'Profile',
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
          ),
        ),
          centerTitle: true,
          elevation: 1,
          actions: <Widget>[
            TextButton(
                onPressed: () => _confirmSignOut(context),
                child: Text('Logout'),
                style: TextButton.styleFrom(
                  primary: Colors.white,
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(130),
            child: _buildUserInfo(Auth().currentUser),
          ),

        ),
        //body: _buildContent(context),
    );
  }
  Widget _buildUserInfo(User? user) {
    return Column(
      children: <Widget>[

        SizedBox(height: 8),
        if (user!.displayName != null)
          Text(
            user.displayName.toString(),
            style: TextStyle(color: Colors.white),
          ),
        SizedBox(height: 8),
        Text(
          user.email.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

}
