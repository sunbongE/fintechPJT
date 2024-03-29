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
  var messageString = "";

  void getMyDeviceToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    UserManager().saveUserInfo(newFcmToken: fcmToken);
    print("Firebase토큰: $fcmToken");
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    _checkForInitialMessage();
    _checkLoginStatus();
    _listenForForegroundMessages();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("포그라운드에서 메시지 수신111122121: ${message.messageId}, 데이터: ${message.notification!.title}");
      },
    );
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
    if (message.data.containsKey('notificationType')) {
      print("푸시알림 데이터: ${message.data}");
      setState(
        () {
          messageString = message.data.toString();
          print(messageString);
        },
      );

      // 알림 타입에 따라 다른 페이지로 이동
      String notificationType = message.data['notificationType'];
      switch (notificationType) {
        case 'group':
          print("groupgroupgroupgroup");
        case 'message':
          print("messagemessagemessagemessage");
        default:
          print("defaultdefaultdefaultdefault");
      }
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
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
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
