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
  Widget _initialScreen = CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    _loadInitialScreen();
  }

  Future<void> _loadInitialScreen() async {
    await UserInfo.loadUserInfo();
    setState(() {
      // _initialScreen = UserInfo.name != null ? HomeScreen() : Login();
      _initialScreen = UserInfo.name != null ? Login() : Login();
    });
  }

  @override
  Widget build(BuildContext context) {
    // status bar 투명하게, 글씨 검정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      // home: isLoginProvider.isLogin ? HomeScreen() : Login(),
      home: _initialScreen,
    );
  }
}
