
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exp/services/api_path.dart';
import 'package:flutter/cupertino.dart';

class Users {
  Users({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userType,
    required this.userId,
  });

  final String firstName;
  final String lastName;
  final String? email;
  final String userType;
  final String userId;

}
