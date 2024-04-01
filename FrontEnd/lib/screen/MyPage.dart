import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/MyInfo.dart';
import 'package:front/components/split/SplitDoing.dart';
import 'package:front/components/split/SplitDone.dart';
import 'package:front/components/split/SplitLoading.dart';
import '../components/calculate/Jjatury.dart';
import '../components/mypage/MyAccount.dart';
import '../components/mypage/MyTripHistory.dart';
import '../components/mypage/ProfileChange.dart';
import '../components/mypage/ProfileChangeBtn.dart';
import '../models/button/Button.dart';
import '../models/button/ButtonSlideAnimation.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with WidgetsBindingObserver {
  void updateMyInfo() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "마이페이지",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyInfo(),
            //감사합니다 잘썼습니다 -지연
            ProfileChangeBtn(
              buttonText: '프로필 수정',
              onPressed: () => buttonSlideAnimation(
                context,
                ProfileChange(
                  onUpdate: () => updateMyInfo(),
                ),
              ),
            ),
            MyAccount(),
            MyTripHistory(),
          ],
        ),
      ),
    );
  }
}
