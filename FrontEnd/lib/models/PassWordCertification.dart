import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/FlutterToastMsg.dart';
import 'package:front/components/intros/KeyBoardBoard.dart';
import 'package:front/components/intros/ShowPassWord.dart';
import 'package:front/repository/api/ApiLogin.dart';
import 'package:lottie/lottie.dart';
import '../../providers/store.dart';

class PassWordCertification extends StatefulWidget {
  final Function onSuccess;

  const PassWordCertification({super.key, required this.onSuccess});

  @override
  State<PassWordCertification> createState() => _PassWordCertificationState();
}

class _PassWordCertificationState extends State<PassWordCertification> {
  PageController pageController = PageController();
  String passWord = '';
  String? confirmPassWord = '';
  bool isLoading = false;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void updatePassword(String val) async {
    setState(() {
      if (val.length <= 6) {
        passWord = val;
      }
    });

    if (passWord.length == 6) {
      setState(() {
        isLoading = true;
      });

      Response res = await putPassWord(passWord);
      print('res.statusCode: ${res.statusCode}');

      if (res.statusCode == 200) {
        widget.onSuccess();
      } else {
        setState(() {
          isLoading = false;
          passWord = '';
        });
        FlutterToastMsg("비밀번호가 일치하지 않습니다.\n다시 입력해주세요.");

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => PassWordCertification(onSuccess: widget.onSuccess)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 100.h, 0, 0),
          child: Container(
            child: isLoading
                ? Center(child: Lottie.asset('assets/lotties/orangewalking.json'))
                : PageView(
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      buildPasswordPage(
                        "비밀번호를 입력하세요",
                        "숫자 6자리",
                        passWord,
                        updatePassword,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordPage(String title, String subTitle, String password, Function(String) onKeyTap) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              height: 2.5.h,
              letterSpacing: 1.0.w,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50.h),
          Text(
            subTitle,
            style: TextStyle(fontSize: 16.sp, color: Colors.black.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50.h),
          showPassWord(password),
          SizedBox(height: 50.h),
          Expanded(
            child: KeyBoardBoard(
              onKeyTap: onKeyTap,
            ),
          ),
        ],
      ),
    );
  }
}
