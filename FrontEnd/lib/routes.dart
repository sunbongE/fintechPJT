import "package:flutter/material.dart";
import 'package:front/screen/HomeScreen.dart';
import 'package:front/screen/GroupMain.dart';
import 'package:front/screen/GroupAdd.dart';

class Routes {
  Routes._();

  static const String home = '/home';
  static const String groupmain = '/groupmain';
  static const String groupadd = '/groupadd';
  static const String myspended = '/myspended';
  static const String mypage = '/mypage';

  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => HomeScreen(),
    groupmain: (BuildContext context) => GroupMain(),
    groupadd: (BuildContext context) => GroupAdd(),

    // myspended: (BuildContext context) => MySpended(),
    // mypage: (BuildContext context) => MyPage(),
  };
}
