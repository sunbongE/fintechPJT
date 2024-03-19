import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/MyTripHistoryDetiail.dart';
import '../../models/button/ButtonSlideAnimation.dart';

class MyTripHistory extends StatefulWidget {
  const MyTripHistory({super.key});

  @override
  State<MyTripHistory> createState() => _MyTripHistoryState();
}

class _MyTripHistoryState extends State<MyTripHistory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () => buttonSlideAnimation(
              context,
              MyTripHistoryDetail(),
            ),
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
            ),
            child: Text(
              "나의 여정 기록",
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
