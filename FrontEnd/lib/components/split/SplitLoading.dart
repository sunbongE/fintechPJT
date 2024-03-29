import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../const/colors/Colors.dart';

class SplitLoading extends StatefulWidget {
  final groupId;
  const SplitLoading({super.key, this.groupId});

  @override
  State<SplitLoading> createState() => _SplitLoadingState();
}

class _SplitLoadingState extends State<SplitLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("정산 진행 중", style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.w900, color: TEXT_COLOR)),
            Text("조금만 기다려주세요", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
            Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset("assets/lotties/skymoney.json", width: 300.w),
                Lottie.asset("assets/lotties/orangewalking.json"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
