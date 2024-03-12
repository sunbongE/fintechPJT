import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:front/screen/HomeScreen.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:front/screen/LogIn.dart';
import 'package:front/routes.dart';
import "package:front/providers/store.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '67ca4770ad20679139010583e0a57684',
    javaScriptAppKey: '506a7e7288e569efa8b05d06206ac60a',
  );
  print("키 해시: " + await KakaoSdk.origin);
  runApp(
    ChangeNotifierProvider(
      create: (context) => IsLogin(),
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
  final isLoginValue = IsLogin();

  @override
  // 앱 시작 시 로그인 상태와 사용자 정보를 불러오기
  void initState() {
    super.initState();
    isLoginValue.loadLoginState().then((_) {
      if (isLoginValue.isLogin) {
        UserInfo.loadUserInfo();
      }
    });
  }

  Widget build(BuildContext context) {
    // status bar 투명하게, 글씨 검정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final isLoginProvider = Provider.of<IsLogin>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      home: isLoginProvider.isLogin ? HomeScreen() : Login(),
      // home: HomeScreen(),
    );
  }
}
