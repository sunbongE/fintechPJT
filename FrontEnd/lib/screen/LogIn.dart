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
  bool _isLoading = false;

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
          _isLoading
              ? CircularProgressIndicator()
              : Center(
                  child: IconButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      bool loginSuccess = await SocialKakao();
                      if (loginSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ServiceIntro()),
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
