import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/FlutterToastMsg.dart';
import 'package:front/components/intros/KeyBoardBoard.dart';
import 'package:front/components/intros/ShowPassWord.dart';
import 'package:local_auth/local_auth.dart';
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
  bool isLoading = true;

  final userManager = UserManager();

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  void loadUserInfo() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });
    await userManager.loadUserInfo();
    if (!mounted) return;
    setState(() {
      confirmPassWord = userManager.password;
      isLoading = false; // 로딩 종료
    });
  }

  void updatePassword(String val) {
    if (!mounted) return;

    setState(() {
      if (val.length <= 6) {
        passWord = val;
        if (passWord.length == 6) {
          if (userManager.password == passWord) {
            widget.onSuccess();
          } else {
            FlutterToastMsg("비밀번호가 일치하지 않습니다.\n다시 입력해주세요.");
            if (!mounted) return;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      PassWordCertification(onSuccess: widget.onSuccess)),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 100.h, 0, 0),
        child: Container(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
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
    );
  }

  Widget buildPasswordPage(String title, String subTitle, String password,
      Function(String) onKeyTap) {
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
            style: TextStyle(
                fontSize: 16.sp, color: Colors.black.withOpacity(0.8)),
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
