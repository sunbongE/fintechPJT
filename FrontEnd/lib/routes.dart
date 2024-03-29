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

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:front/screen/HomeScreen.dart';
// import 'package:front/screen/GroupMain.dart';
// import 'package:front/screen/LogIn.dart';
// import 'package:front/screen/MyPage.dart';
// import 'package:front/screen/groupscreens/GroupItem.dart';
//
// class AppRoutes {
//   static final router = GoRouter(
//     routes: <GoRoute>[
//       GoRoute(
//         path: '/',
//         builder: (context, state) => HomeScreen(),
//         routes: <RouteBase>[
//           GoRoute(
//             path: 'login',
//             builder: (context, state) => Login(),
//           ),
//           GoRoute(
//             path: 'groupmain',
//             builder: (context, state) => GroupMain(),
//           ),
//           GoRoute(
//             path: 'mypage',
//             builder: (context, state) => MyPage(),
//           ),
//           // 다른 라우트들도 이와 같은 방식으로 추가하세요.
//           GoRoute(
//             path: 'groups/:groupId/invite',
//             builder: (context, state) {
//               final groupIdString = state.pathParameters['groupId'];
//               final groupId = groupIdString != null ? int.tryParse(groupIdString) : null;
//               if (groupId == null) {
//                 throw Exception('Invalid group ID');
//               }
//               return GroupItem(groupId: groupId);
//             },
//           ),
//         ],
//       ),
//     ],
//   );
// }
