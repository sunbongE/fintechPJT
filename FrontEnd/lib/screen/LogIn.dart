import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front/components/intros/ServiceIntro.dart';
import 'package:front/components/login/SocialKakao.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:lottie/lottie.dart';
import '../providers/store.dart';
import '../repository/api/ApiLogin.dart';

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
              ? Lottie.asset('assets/lotties/orangewalking.json')
              : Center(
                  child: IconButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      User? user = await SocialKakao();
                      print(user);
                      if (user != null) {
                        Response res = await postUserInfo(user);
                        print(1111111);
                        print(res.headers['Authorization']!.first);
                        UserManager().saveUserInfo(
                          newName: user.kakaoAccount?.name,
                          newEmail: user.kakaoAccount?.email,
                          newThumbnailImageUrl: user.kakaoAccount?.profile?.thumbnailImageUrl,
                          newProfileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
                          newJwtToken: res.headers['Authorization']!.first,
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => ServiceIntro()),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                          (Route<dynamic> route) => false,
                        );
                      }
                      ;
                    },
                    icon: Image.asset(
                      "assets/images/kakao_login_btn.png",
                      width: 500,
                    ),
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
