
import 'package:exp/services/auth.dart';
import 'package:flutter/material.dart';
import 'email_sign_in_form.dart';

class EmailPage extends StatelessWidget {
  EmailPage({required this.auth});
  final AuthBase auth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: EmailForm(auth: auth,),
        ),
      )
    );
  }

  Widget _buildContent() {
    return Container();
  }
}
