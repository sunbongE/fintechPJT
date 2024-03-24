import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

class MoneyRequestDetailBottom extends StatefulWidget {
  final int amount;

  MoneyRequestDetailBottom({
    required this.amount,
  });

  @override
  _MoneyRequestDetailBottomState createState() =>
      _MoneyRequestDetailBottomState();
}

class _MoneyRequestDetailBottomState extends State<MoneyRequestDetailBottom> {
  late bool isSettledStates;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 10.h)),
        Tooltip(
          message: '자투리 금액은 \n최종 정산을 늦게한 분이 \n정산하게 됩니다',
          waitDuration: Duration(milliseconds: 1),
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
          '${widget.amount}원',
          style: TextStyle(color: TEXT_COLOR, fontSize: 14.sp),
        ),
      ],
    );
  }
}
