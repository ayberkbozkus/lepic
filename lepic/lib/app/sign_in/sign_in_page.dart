import 'dart:ui';
import 'package:exp/app/sign_in/sign_in_with_email.dart';
import 'package:exp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lepic Reading Fluency Assesment App'),
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          SignInButton(
            Buttons.Google,
            text: "Sign up with Google",
            onPressed: _signInWithGoogle,
          ),
          SizedBox(height: 10.0),
          SignInButton(
            Buttons.FacebookNew,
            text: "Sign up with Facebook",
            onPressed: () {},
          ),
          SizedBox(height: 8.0),
          SignInButtonBuilder(
            text: 'Sign up with Email',
            icon: Icons.email,
            onPressed: () => _signInWithEmail(context),
            backgroundColor: Colors.blueGrey[700]!,
          ),
        ],
      ),
    );
  }

  void _signInWithGoogle() async {
    // To do auth with google
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailPage(auth: auth),
    ));
  }
}