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

import '../repository/api/ApiLogin.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  var messageString = "";

  void getMyDeviceToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    UserManager().saveUserInfo(newFcmToken: fcmToken);
    print("Firebase토큰: $fcmToken");
  }

  @override
  void initState() {
    super.initState();
    _checkForInitialMessage();
    _checkLoginStatus();
    _listenForForegroundMessages();
  }

  // 푸시알림으로 앱이 시작됐을 때 초기 메시지 처리
  void _checkForInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  // 앱이 백그라운드 상태에서 푸시알림을 통해 열렸을 때 메시지 처리
  void _listenForForegroundMessages() {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  // 메시지 처리 로직
  void _handleMessage(RemoteMessage message) {
    // 메시지에 'type' 키가 있다고 가정하고 처리
    if (message.data.containsKey('notificationType')) {
      print("푸시알림 데이터: ${message.data}");
      setState(() {
        messageString = message.data.toString();
      });
      // 여기서 필요한 로직을 추가하세요.
      // 예: 특정 groupId로 이동
      // if (message.data['type'] == 'group') {
      //   print(9999);
      // }
    }
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
        // 만약 푸시알림으로 입장한 사용자면, groupId 처럼 특정 데이터가 있을 거임. 그 곳으로 이동해야함.
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PassWordCertification(onSuccess: () {
                      // 만약 푸시알림으로 입장한 사용자면, groupId 처럼 특정 데이터가 있을 거임. 그 곳으로 이동해야함.
                      if (mounted) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
                      }
                    })));
          }
        });
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Image.asset("assets/images/logo.png"), Lottie.asset('assets/lotties/orangewalking.json')],
        ),
      ),
    );
  }
}
