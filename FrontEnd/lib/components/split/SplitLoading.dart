import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../const/colors/Colors.dart';
import 'SplitDone.dart';
import 'SplitResult.dart';

class SplitLoading extends StatefulWidget {
  final groupId;

  const SplitLoading({super.key, this.groupId});

  @override
  State<SplitLoading> createState() => _SplitLoadingState();
}

class _SplitLoadingState extends State<SplitLoading> {
  void initState() {
    super.initState();
    //여기서 포스트 요청이 성공으로 끝나면
    // 3초 후에 SplitResult 페이지로 이동
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SplitDone(groupId: widget.groupId)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("정산 진행 중",
                  style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w900,
                      color: TEXT_COLOR)),
              Text("조금만 기다려주세요",
                  style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
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
      ),
    );
  }
}
