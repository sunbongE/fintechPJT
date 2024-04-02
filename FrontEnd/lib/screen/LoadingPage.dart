import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:front/models/Biometrics.dart';
import 'package:front/models/PassWordCertification.dart';
import 'package:front/providers/store.dart';
import 'package:front/screen/HomeScreen.dart';
import 'package:front/screen/LogIn.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../repository/api/ApiLogin.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void getMyDeviceToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    UserManager().saveUserInfo(newFcmToken: fcmToken);
    print("Firebase토큰: $fcmToken");
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    _checkLoginStatus();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _checkLoginStatus() async {
    var userManager = Provider.of<UserManager>(context, listen: false);
    await userManager.loadUserInfo();
    print("로그인 상황: ${userManager.isLogin}");
    print("토큰토큰: ${userManager.jwtToken}");
    getMyDeviceToken();

    if (userManager.isLogin ?? false) {
      postFcmToken(userManager.fcmToken);
      bool authenticated = await _authenticate();
      if (authenticated) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
          );
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PassWordCertification(
                    onSuccess: () {
                      if (mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                  ),
                ),
              );
            }
          },
        );
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Login()));
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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Image.asset("assets/images/logo.png"), Lottie.asset('assets/lotties/orangewalking.json')],
          ),
        ),
      ),
    );
  }
}
