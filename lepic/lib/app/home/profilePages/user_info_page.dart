import 'package:exp/app/home/model/user.dart';
import 'package:exp/app/home/profilePages/profile_page.dart';
import 'package:exp/app/landing_page.dart';
import 'package:exp/services/auth.dart';
import 'package:exp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoPage extends StatefulWidget {

  const UserInfoPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;


  @override
  _UserInfoPageState createState() =>
      _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {

  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _secretController = TextEditingController();
  String get firstName => _firstnameController.text;
  String get lastName => _lastnameController.text;
  String get secretKey => _secretController.text;

  String dropdownValue = 'Select User Type';
  String _userType = '' ;
  String _secretKey = '';



  Future<void> writeFb() async{
    final email = await widget.auth.getCurrentUserEmail();


    final newUser = Users(firstName: firstName,
      lastName: lastName,
      email: email,
      userType: _userType,
      userId: '',
    );
    final database = Provider.of<Database>(context, listen: false);
    await database.createUser(newUser);
    //Navigator.of(context).pop();
  }

  Future<void> _save() async {

    // TODO firestore crud
    if(_userType == 'Select User Type' ){
      final dr = await _showAlertDialog(
        context: context,
        titleText: 'Error',
        messageText:
        'Please select an user type.',
      );
    }
    else if (_userType == ''){
      final dr = await _showAlertDialog(
        context: context,
        titleText: 'Error',
        messageText:
        'Please select an user type.',
      );
    }
    else if (_userType == 'Teacher'){
      final dr = await _displayTextInputDialog(context:context);
      bool? res = await _checkTheKey(_secretKey);
      if(res==true){
        writeFb();
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  LandingPage(auth: widget.auth)),
        );
      }
      else {
        final dr = await _showAlertDialog(
          context: context,
          titleText: 'Wrong Key',
          messageText:
          'Please confirm the user type.',
        );
      }
    }
    else if (_userType == 'Researcher'){
      final dr = await _displayTextInputDialog(context:context);
      bool? res = await _checkTheKey(_secretKey);
      if(res==true){
        writeFb();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  LandingPage(auth: widget.auth)),
        );
      }
      else {
        final dr = await _showAlertDialog(
          context: context,
          titleText: 'Wrong Key',
          messageText:
          'Please confirm the user type.',
        );
      }
    }
    else if (_userType == 'Parent'){
      final dr = await _displayTextInputDialog(context:context);
      bool? res = await _checkTheKey(_secretKey);
      if(res==true){
        writeFb();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  LandingPage(auth: widget.auth)),
        );
      }
      else {
        final dr = await _showAlertDialog(
          context: context,
          titleText: 'Wrong Key',
          messageText:
          'Please confirm the user type.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Credentials'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed:() => _save(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _firstnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _lastnameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
            ),

            DropdownButton<String>(value: dropdownValue,
              alignment: Alignment.center,
              hint: Text("I am a ..."),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: <String>['Select User Type','Teacher', 'Researcher', 'Parent']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  _userType = dropdownValue;
                  }
                );
              } ,
            ),
          ],
        ),
      ),
    );
  }

  Future<Future> _showAlertDialog({
    required BuildContext context,
    required String titleText,
    required String messageText,
  }) async {
    // set up the buttons
    final Widget okButton = TextButton(
      onPressed: () => Navigator.pop(context, 'OK'),
      child: const Text('OK'),
    );
    // set up the AlertDialog
    final alert = AlertDialog(
      title: Text(titleText),
      content: Text(messageText),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    return showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  Future<void> _displayTextInputDialog({required BuildContext context}) async {
    return showDialog(
        context: context,
        builder: (context) {
          _secretController.text="";
          return AlertDialog(
            title: Text('Enter The Secret Key'),
            content: TextField(
              onChanged: (String? value) {
                setState(() {
                  _secretKey = value!;
                });
              },
              controller: _secretController,
            ),
            actions: <Widget>[

              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              // ignore: deprecated_member_use
              TextButton(

                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );

        });
  }

  Future<bool?> _checkTheKey(String secretKey) async {
    if(_userType == 'Teacher'){
      if(_secretKey == 'teacher'){
        return Future<bool>.value(true);
      }
      else
        return Future<bool>.value(false);
    }
    if(_userType == 'Researcher'){
      if(_secretKey == 'res'){
        return Future<bool>.value(true);
      }
      else
        return Future<bool>.value(false);
    }
    if(_userType == 'Parent'){
      if(_secretKey == 'parent'){
        return Future<bool>.value(true);
      }
      else
        return Future<bool>.value(false);
    }
  }
}
