import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

DateTime? currentBackPressTime;

Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(
        msg: "'뒤로' 버튼을 한번 더 누르시면 종료됩니다.",
        gravity: ToastGravity.BOTTOM,
        // backgroundColor: Colors.grey,
        fontSize: 20,
        toastLength: Toast.LENGTH_SHORT);
    return Future.value(false);
  }
  return Future.value(true);
}
