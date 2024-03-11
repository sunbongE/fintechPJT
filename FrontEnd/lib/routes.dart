import "package:flutter/material.dart";
import 'package:front/screen/HomeScreen.dart';

class Routes {
  Routes._();
  static const String home =  '/home';
  static const String groupmain =  '/groupmain';
  static const String myspended =  '/myspended';
  static const String mypage =  '/mypage';

  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => HomeScreen(),
    // groupmain: (BuildContext context) => GroupMain(),
    // myspended: (BuildContext context) => MySpended(),
    // mypage: (BuildContext context) => MyPage(),
  };

}