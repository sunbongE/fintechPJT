import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: GREY_COLOR,
      height: 0,
      thickness: 1.sp,
      indent: 20.w,
      endIndent: 20.w,
    );
  }
}