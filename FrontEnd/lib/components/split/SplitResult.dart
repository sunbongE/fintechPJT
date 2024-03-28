import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors/Colors.dart';

class SplitResult extends StatefulWidget {
  const SplitResult({super.key});

  @override
  State<SplitResult> createState() => _SplitResultState();
}

class _SplitResultState extends State<SplitResult> {
  bool isMinus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("{김신영}님께", style: TextStyle(fontSize: 20.sp)),
        Container(
          margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10.r)),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: PRIMARY_COLOR, size: 40.w),
                      SizedBox(width: 8.w),
                      Text("보낸 금액", style: TextStyle(fontSize: 16.sp)),
                    ],
                  ),
                ),
                Text('{-30,800}원', style: TextStyle(fontSize: 18.sp, color: isMinus ? Colors.green : Colors.red)),
                IconButton(onPressed: () {}, icon: Icon(Icons.info_outline, color: RECEIPT_TEXT_COLOR, size: 20.h)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
