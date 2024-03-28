import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/FlutterToastMsg.dart';
import 'package:front/components/intros/KeyBoardBoard.dart';
import 'package:front/components/intros/ShowPassWord.dart';
import 'package:front/components/selectbank/SelectBank.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';
import 'package:front/repository/api/ApiLogin.dart';
import 'package:local_auth/local_auth.dart';
import '../../models/Biometrics.dart';
import '../../providers/store.dart';

class CreatePwPage extends StatefulWidget {
  const CreatePwPage({super.key});

  @override
  State<CreatePwPage> createState() => _CreatePwPageState();
}

class _CreatePwPageState extends State<CreatePwPage> {
  PageController _pageController = PageController();
  String _passWord = '';
  String _confirmPassWord = '';
  final LocalAuthentication auth = LocalAuthentication();

  // 비밀번호 입력
  void _updatePassword(String val) {
    setState(
      () {
        if (val.length <= 6) {
          _passWord = val;
          if (_passWord.length == 6) {
            _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          }
        }
      },
    );
  }

  // 컨펌비밀번호 입력 및 유효성검사
  void _updateConfirmPassWord(String val) async {
    setState(() {
      if (val.length <= 6) {
        _confirmPassWord = val;
      }
    });

    if (_confirmPassWord.length == 6) {
      if (_confirmPassWord == _passWord) {
        var userManager = UserManager();
        userManager.loadUserInfo();

        bool? authenticated = await CheckBiometrics();
        if (authenticated == true) {
          FlutterToastMsg("생체 인증이 등록되었습니다.");
        } else {
          FlutterToastMsg("생체 인증이 등록되지 않았습니다.\n다음에 다시 등록해주세요.");
        }
        // 핀 번호 post API
        await postPassWord(_confirmPassWord);
        // FCM토큰 post api
        await postFcmToken(userManager.fcmToken);

        UserManager().saveUserInfo(newPassword: _confirmPassWord);
        buttonSlideAnimation(context, SelectBank());
      } else {
        FlutterToastMsg("비밀번호가 일치하지 않습니다.\n다시 입력해주세요.");
        setState(() {
          _confirmPassWord = '';
          _passWord = '';
        });
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
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
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                buildPasswordPage(
                  "여정에서 사용할\n비밀번호를 설정하세요",
                  "숫자 6자리",
                  1,
                  _passWord,
                  _updatePassword,
                ),
                buildPasswordPage(
                  "비밀번호를\n한 번 더 입력해주세요",
                  "숫자 6자리",
                  2,
                  _confirmPassWord,
                  _updateConfirmPassWord,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordPage(String title, String subTitle, int idx, String password, Function(String) onKeyTap) {
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
          idx == 1 ? showPassWord(password) : showPassWord(_confirmPassWord),
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
