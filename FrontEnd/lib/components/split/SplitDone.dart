import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/split/SplitResult.dart';
import 'package:front/const/colors/Colors.dart';

class SplitDone extends StatefulWidget {
  const SplitDone({super.key});

  @override
  State<SplitDone> createState() => _SplitDoneState();
}

class _SplitDoneState extends State<SplitDone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("정산 완료", style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: TEXT_COLOR)),
              Text("여정이 정산을 정리했어요", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 40.h,
              ),
              Expanded(child: SplitResult()),
            ],
          ),
        ),
      ),
    );
  }
}
