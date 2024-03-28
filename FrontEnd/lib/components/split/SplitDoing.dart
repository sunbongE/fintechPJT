import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/split/SplitMembers.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:lottie/lottie.dart';

class SplitDoing extends StatefulWidget {
  const SplitDoing({super.key});

  @override
  State<SplitDoing> createState() => _SplitDoingState();
}

class _SplitDoingState extends State<SplitDoing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("정산 진행 상황", style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: TEXT_COLOR)),
              Text("정산이 아직 진행 중이에요", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
              Lottie.asset("assets/lotties/orangewalking.json", width: 200.w),
              // 스플릿 정산 레디가 되었는지 확인하는 목록
              Expanded(child: SplitMembers()),
            ],
          ),
        ),
      ),
    );
  }
}
