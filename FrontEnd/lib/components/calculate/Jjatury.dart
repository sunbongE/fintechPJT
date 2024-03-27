import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:front/screen/HomeScreen.dart';
import 'package:lottie/lottie.dart';

class Jjatury extends StatefulWidget {
  const Jjatury({super.key});

  @override
  State<Jjatury> createState() => _JjaturyState();
}

class _JjaturyState extends State<Jjatury> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "자투리 정산에 당첨되셨어요!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            Text(
              "10원",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 36.sp, color: PRIMARY_COLOR),
            ),
            Lottie.asset('assets/lotties/jjatury.json'),
            // Lottie.asset('assets/lotties/orangewalking.json'),
            SizedButton(
              btnText: "확인",
              size: ButtonSize.s,
              onPressed: () => buttonSlideAnimationPushAndRemoveUntil(context, 0),
            )
          ],
        ),
      ),
    );
  }
}
