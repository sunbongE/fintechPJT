import "package:flutter/material.dart";
import 'package:front/screen/HomeScreen.dart';
import 'package:front/screen/GroupMain.dart';
import 'package:front/screen/LogIn.dart';
import 'package:front/screen/MyPage.dart';

class Routes {
  Routes._();

  static const String home = '/home';
  static const String login = '/login';
  static const String groupmain = '/groupmain';
  static const String groupadd = '/groupadd';
  static const String myspended = '/myspended';
  static const String mypage = '/mypage';

  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => HomeScreen(),
    groupmain: (BuildContext context) => GroupMain(),
    login: (BuildContext context) => Login(),
    mypage: (BuildContext context) => MyPage(),

    // myspended: (BuildContext context) => MySpended(),
    // mypage: (BuildContext context) => MyPage(),
  };
}
