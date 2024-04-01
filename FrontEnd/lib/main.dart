import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/repository/api/ApiGroup.dart';
import 'package:front/screen/LoadingPage.dart';
import 'package:front/screen/MainPage.dart';
import 'package:front/screen/groupscreens/GroupItem.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:front/routes.dart';
import "package:front/providers/store.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences는 간단한 데이터를 로컬에 저장할 때 사용
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드에서 오는 메세지: ${message.data}");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('groupId', int.parse(message.data['groupId']));
  await prefs.setString('type', message.data['type']);
  print('SharedPreferences에 저장됨: groupId = ${message.data['groupId']}, type = ${message.data['type']}');
}

@pragma('vm:entry-point')
void backgroundHandler(NotificationResponse details) {
  print("2222메세지 받고싶다..: ${details}");
}

void initializeNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
      const AndroidNotificationChannel('high_importance_channel', 'high_importance_notification', importance: Importance.max));
  await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@ipmap/ic_launcher"),
      ), onDidReceiveNotificationResponse: (details) async {
    print("1111메세지 받고싶다..: ${details.payload}");
  }, onDidReceiveBackgroundNotificationResponse: backgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails('high_importance_channel', 'high_importance_notification', importance: Importance.max),
          ),
          payload: message.data['test_params1']);

      print("메세지 받았슴다~~~~~~~");
    }
  });

  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    print("메세지 받았슴다22222");
  }
}

Future<void> main() async {
  await dotenv.load(fileName: "yeojung-env/ssafy_c203_env/.env");
  WidgetsFlutterBinding.ensureInitialized();
  initializeNotification();
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!,
    javaScriptAppKey: dotenv.env['KAKAO_JAVASCRIPT_APP_KEY']!,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  print('키 해시: ${await KakaoSdk.origin}');

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserManager(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return ScreenUtilInit(
      designSize: Size(430, 932),
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: Routes.routes,
        home: Scaffold(
          body: LoadingPage(),
        ),
      ),
    );
  }
}
