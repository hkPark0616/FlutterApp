import 'package:flutter/material.dart';

class RecommentsUpdator extends ChangeNotifier {
  List _recommentsList = [];
  List get recommentsList => _recommentsList;

  // 리스트 업데이트
  void updateList(List newList) {
    _recommentsList = newList;
    notifyListeners();
  }
}
