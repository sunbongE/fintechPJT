import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/screen/HomeScreen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:front/screen/LogIn.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLogin ? HomeScreen() : LogIn(),
      // home: HomeScreen(),
    );
  }
}
