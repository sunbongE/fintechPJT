import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/Biometrics.dart';
import 'package:front/models/PassWordCertification.dart';
import 'package:front/providers/store.dart';
import 'package:front/screen/HomeScreen.dart';
import 'package:front/screen/LogIn.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A new onMessageOpenedApp event was published!");
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (_) => HomeScreen()),
      // );
    });
  }

  Future<void> _checkLoginStatus() async {
    var userManager = Provider.of<UserManager>(context, listen: false);
    await userManager.loadUserInfo();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    UserManager().saveUserInfo(newFcmToken: fcmToken);

    print("로그인 상황: ${userManager.isLogin}");
    print("토큰토큰: ${userManager.jwtToken}");
    print("Firebase토큰: $fcmToken");

    if (userManager.isLogin ?? false) {
      bool authenticated = await _authenticate();
      if (authenticated) {
        // 만약 푸시알림으로 입장한 사용자면, groupId 처럼 특정 데이터가 있을 거임. 그 곳으로 이동해야함.
        if (mounted) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PassWordCertification(onSuccess: () {
                  // 만약 푸시알림으로 입장한 사용자면, groupId 처럼 특정 데이터가 있을 거임. 그 곳으로 이동해야함.
                      if (mounted) {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => HomeScreen()));
                      }
                    })));
          }
        });
      }
    } else {
      if (mounted) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
      }
    }
  }

  Future<bool> _authenticate() async {
    bool? authenticated = await CheckBiometrics();
    return authenticated ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png"),
            SizedBox(height: 50.h),
            Lottie.asset('assets/lotties/orangewalking.json')
          ],
        ),
      ),
    );
  }
}
