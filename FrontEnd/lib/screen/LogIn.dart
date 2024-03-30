import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front/components/intros/ServiceIntro.dart';
import 'package:front/components/login/SocialKakao.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../models/Biometrics.dart';
import '../models/PassWordCertification.dart';
import '../providers/store.dart';
import '../repository/api/ApiLogin.dart';
import 'HomeScreen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final List<Map<String, String>> bankList = [
    {'name': '한국은행', 'code': '001'},
    {'name': '광주은행', 'code': '002'},
    {'name': '농협은행주식회사', 'code': '003'},
    {'name': '대구은행', 'code': '004'},
    {'name': '부산은행', 'code': '005'},
    {'name': '수협은행', 'code': '006'},
    {'name': '신한은행', 'code': '007'},
    {'name': '우리은행', 'code': '008'},
    {'name': '전북은행', 'code': '009'},
    {'name': '주식회사 카카오뱅크', 'code': '010'},
    {'name': '주식회사 케이뱅크', 'code': '011'},
    {'name': '중소기업은행', 'code': '012'},
    {'name': '토스뱅크 주식회사', 'code': '013'},
    {'name': '하나은행', 'code': '014'},
    {'name': '한국산업은행', 'code': '015'},
    {'name': '한국스탠다드차타드은행', 'code': '016'},
    {'name': '경남은행', 'code': '017'},
    {'name': '국민은행', 'code': '018'},
    {'name': '제주은행', 'code': '019'},
  ];

  Future<void> _checkLoginStatus() async {
    var userManager = Provider.of<UserManager>(context, listen: false);
    await userManager.loadUserInfo();

    print("로그인 상황: ${userManager.isLogin}");
    print("토큰토큰: ${userManager.jwtToken}");
    postFcmToken(userManager.fcmToken);
    bool authenticated = await _authenticate();
    if (authenticated) {
      if (mounted) {
        Response res = await getMyPrimary();
        String bankCode = res.data['bankCode'];
        String bankName = '';
        for (var bank in bankList) {
          if (bank['code'] == bankCode) {
            bankName = bank['name']!;
            break;
          }
        }
        await userManager.saveUserInfo(
          newSelectedAccount: res.data['accountNo'],
          newSelectedBank: bankName,
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PassWordCertification(
                  onSuccess: () async {
                    if (mounted) {
                      Response res = await getMyPrimary();

                      String bankCode = res.data['bankCode'];
                      String bankName = '';
                      for (var bank in bankList) {
                        if (bank['code'] == bankCode) {
                          bankName = bank['name']!;
                          break;
                        }
                      }
                      await userManager.saveUserInfo(
                        newSelectedAccount: res.data['accountNo'],
                        newSelectedBank: bankName,
                      );
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
                    }
                  },
                ),
              ),
            );
          }
        },
      );
    }
  }

  Future<bool> _authenticate() async {
    bool? authenticated = await CheckBiometrics();
    return authenticated ?? false;
  }

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
                      if (user != null) {
                        Response res = await postUserInfo(user);
                        UserManager().saveUserInfo(
                          newName: user.kakaoAccount?.name,
                          newEmail: user.kakaoAccount?.email,
                          newThumbnailImageUrl: user.kakaoAccount?.profile?.thumbnailImageUrl,
                          newProfileImageUrl: user.kakaoAccount?.profile?.profileImageUrl,
                          newJwtToken: res.headers['Authorization']!.first,
                        );
                        if (res.statusCode == 201) {
                          print("힝 201이지?");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => ServiceIntro()),
                            (Route<dynamic> route) => false,
                          );
                        } else if (res.statusCode == 200) {
                          print("힝 200이지?");
                          _checkLoginStatus();
                        }
                      } else {
                        print("힝 속았지?");
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                          (Route<dynamic> route) => false,
                        );
                      }
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
