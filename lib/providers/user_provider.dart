import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider{
  User user = FirebaseAuth.instance.currentUser;
}