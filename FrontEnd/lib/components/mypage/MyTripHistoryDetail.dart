import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/MyTripHistoryGroupDetail.dart';
import 'package:front/components/myspended/MySpendList.dart';
import '../../const/colors/Colors.dart';
import '../../entities/Group.dart';

class MyTripHistoryDetail extends StatefulWidget {
  final Group groupData;

  const MyTripHistoryDetail({required this.groupData, super.key});

  @override
  State<MyTripHistoryDetail> createState() => _MyTripHistoryDetailState();
}

class _MyTripHistoryDetailState extends State<MyTripHistoryDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          widget.groupData.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        backgroundColor: BG_COLOR,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: 430.w,
              height: 200.h,
              decoration: BoxDecoration(
                color: BG_COLOR,
              ),
              child: MyTripHistoryGroupDetail(
                startDate: widget.groupData.startDate,
                endDate: widget.groupData.endDate,
                description: widget.groupData.description,
              ),
            ),
            MySpendList(),
          ],
        ),
      ),
    );
  }
}
