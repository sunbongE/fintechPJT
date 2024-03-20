import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/MyTripHistoryList.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            onPressed: () => buttonSlideAnimation(
              context,
              MyTripHistoryList(),
            ),
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "나의 여정 기록",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
