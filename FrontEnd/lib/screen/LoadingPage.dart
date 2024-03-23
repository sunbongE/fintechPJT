import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/Biometrics.dart';
import 'package:front/models/PassWordCertification.dart';
import 'package:front/providers/store.dart';
import 'package:front/screen/HomeScreen.dart';
import 'package:front/screen/LogIn.dart';
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
  }

  Future<void> _checkLoginStatus() async {
    var userManager = Provider.of<UserManager>(context, listen: false);
    await userManager.loadUserInfo();
    print("로그인 상황: ${userManager.isLogin}");
    print("로그인 상황: ${userManager.jwtToken}");

    if (userManager.isLogin ?? false) {
      bool authenticated = await _authenticate();
      if (authenticated) {
        if (mounted) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PassWordCertification(onSuccess: () {
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
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
