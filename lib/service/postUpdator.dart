import 'package:flutter/material.dart';

class PostUpdator extends ChangeNotifier {
  List _postList = [];
  List get postList => _postList;

  // 리스트 업데이트
  void updateList(List newList) {
    _postList = newList;
    notifyListeners();
  }
}
