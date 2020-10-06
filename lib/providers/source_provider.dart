import 'package:flutter/material.dart';
class SourceProvider extends ChangeNotifier{
  var source = 0;

  void setSource(var index) {
    source = index;
    notifyListeners();
  }
}