import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors/Colors.dart';

class ShowReceiptBtn extends StatelessWidget {
  final VoidCallback onPressed;

  const ShowReceiptBtn({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            '영수증 보기',
            style: TextStyle(
                color: TEXT_COLOR,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
