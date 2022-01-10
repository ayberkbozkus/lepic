import 'package:exp/app/home/model/class.dart';
import 'package:flutter/material.dart';


class ClassListTile extends StatelessWidget {
  const ClassListTile({Key? key, required this.classes, required this.onTap, required this.onLongPress}) : super(key: key);
  final Classes classes;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(classes.className),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
      onLongPress: onLongPress,
      // TODO onlong press edit
    );
  }
}