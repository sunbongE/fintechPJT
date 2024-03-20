import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoneyRequestDetailBottom extends StatelessWidget {
  final int amount;
  final Color textColor;

  MoneyRequestDetailBottom({required this.amount, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 10.h)),
        Tooltip(
          message: '자투리 금액은 \n최종 정산을 늦게한 분이 \n정산하게 됩니다',
          textAlign: TextAlign.center,
          child: Row(
            children: [
              Icon(Icons.info_outline),
              Padding(padding: EdgeInsets.symmetric(horizontal: 3.h)),
              Text(
                '자투리 금액',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: TextStyle(color: Colors.black),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 3.h)),
        Text('|'),
        Padding(padding: EdgeInsets.symmetric(horizontal: 3.h)),
        Text(
          '$amount원',
          style: TextStyle(color: textColor, fontSize: 14.sp),
        ),
      ],
    );
  }
}
