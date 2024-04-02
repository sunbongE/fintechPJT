import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../screen/MoneyRequest.dart';

class GroupNoCal extends StatelessWidget {
  final int groupId;
  const GroupNoCal({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.0.h),
        Image.asset(
          'assets/images/empty.png',
          width: 250.w,
          height: 200.h,
        ),
        SizedBox(height: 6.0.h),
        Text(
          '정산 요청이 비어있어요',
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
