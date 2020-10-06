import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MovieEventProvider extends ChangeNotifier {
  DateTime targetDate;
  var remainingDays;
  var _db = FirebaseFirestore.instance;
  FirebaseMessaging _fcm = FirebaseMessaging();

  getEvent() async {
    DocumentSnapshot ds = await _db.collection('Events').doc('nextEvent').get();
    targetDate = ds['targetDate'].toDate();
  }

  getRemainingTime(){
    remainingDays = targetDate.difference(DateTime.now()).inDays;
    
    return remainingDays;
  }

  subscirbeToVoteList() {
    _fcm.subscribeToTopic('voteList');
  }
  unsubscribeToVoteList() {
    _fcm.unsubscribeFromTopic('voteList');
  }  
  subscirbeToAttendList() {
    _fcm.subscribeToTopic('attendList');
  }
  unsubscribeToAttendList() {
    _fcm.unsubscribeFromTopic('attendList');
  }  
}
