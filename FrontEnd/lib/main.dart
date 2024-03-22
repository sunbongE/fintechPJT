import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/screen/LoadingPage.dart';
import 'package:provider/provider.dart';
import 'package:front/screen/HomeScreen.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:front/screen/LogIn.dart';
import 'package:front/routes.dart';
import "package:front/providers/store.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'models/Biometrics.dart';
import 'models/PassWordCertification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: "yeojung-env/ssafy_c203_env/.env");
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!,
    javaScriptAppKey: dotenv.env['KAKAO_JAVASCRIPT_APP_KEY']!,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("키 해시: " + await KakaoSdk.origin);

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
  var userManager = UserManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    var userManager = Provider.of<UserManager>(context, listen: false);

    return ScreenUtilInit(
      designSize: Size(430, 932),
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: Routes.routes,
        home: FutureBuilder(
          future: userManager.loadUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (userManager.isLogin ?? false) {
                return FutureBuilder<bool>(
                  future: _authenticate(),
                  builder: (context, authSnapshot) {
                    if (authSnapshot.connectionState == ConnectionState.done) {
                      if (authSnapshot.data == true) {
                        return HomeScreen();
                      } else {
                        return PassWordCertification(onSuccess: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => HomeScreen()));
                        });
                      }
                    }
                    return LoadingPage();
                  },
                );
              } else {
                return Login();
              }
            }
            return LoadingPage();
          },
        ),
      ),
    );
  }

  Future<bool> _authenticate() async {
    bool? authenticated = await CheckBiometrics();
    return authenticated ?? false;
  }
}
