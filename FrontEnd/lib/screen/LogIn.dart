import 'package:flutter/material.dart';
import 'package:front/components/intros/ServiceIntro.dart';
import 'package:front/components/login/SocialKakao.dart';
import 'package:provider/provider.dart';

import '../providers/store.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/logo.png'),
          ),
          SizedBox(
            height: 100,
          ),
          Center(
            child: IconButton(
              onPressed: () async {
                bool loginSuccess = await SocialKakao();
                if (loginSuccess) {
                  Provider.of<IsLogin>(context, listen: false).loginState();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ServiceIntro()),
                  );
                }
              },
              icon: Image.asset(
                "assets/images/kakao_login_btn.png",
                width: 500,
              ),
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
