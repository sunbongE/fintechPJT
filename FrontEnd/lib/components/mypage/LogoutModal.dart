import 'package:flutter/material.dart';
import 'package:front/components/login/SocialKakao.dart';
import '../../main.dart';

void LogoutModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('로그아웃'),
        content: Text('로그아웃하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            child: Text('아니오'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('네'),
            onPressed: () async {
              await logoutKakao();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}
