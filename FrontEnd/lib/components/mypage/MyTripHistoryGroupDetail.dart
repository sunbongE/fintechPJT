import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:front/const/colors/Colors.dart';

class MyTripHistoryGroupDetail extends StatefulWidget {
  final String startDate;
  final String endDate;
  final String description;

  const MyTripHistoryGroupDetail({
    required this.startDate,
    required this.endDate,
    required this.description,
    super.key,
  });

  @override
  State<MyTripHistoryGroupDetail> createState() =>
      _MyTripHistoryGroupDetailState();
}

class _MyTripHistoryGroupDetailState extends State<MyTripHistoryGroupDetail> {
  // 현재 잔액 불러오는 api
  int myMoneyAmount = 32733;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.w),
      child: Column(
        children: [
          Text(
            '${widget.startDate} - ${widget.endDate}',
            style: TextStyle(
              fontSize: 13.sp,
              color: Color(0xff6E6E6E),
            ),
          ),
          Text(
            '${widget.description}',
            style: TextStyle(
              color: TEXT_COLOR,
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
