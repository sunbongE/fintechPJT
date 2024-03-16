import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../const/colors/Colors.dart';

void FlutterToastMsg (String msg) {
  Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: PRIMARY_COLOR,
      fontSize: 16.0);
}