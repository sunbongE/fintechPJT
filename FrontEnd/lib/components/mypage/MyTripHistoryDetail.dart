import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/MyTripHistoryGroupDetail.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';
import 'package:front/models/button/SizedButton.dart';
import '../../const/colors/Colors.dart';
import '../../entities/Group.dart';
import 'GroupMap.dart';
import 'GroupSpendList.dart';

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
          widget.groupData.groupName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        backgroundColor: BG_COLOR,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: 430.w,
            // height: 200.h,
            decoration: BoxDecoration(
              color: BG_COLOR,
            ),
            child: Column(
              children: [
                MyTripHistoryGroupDetail(
                  startDate: widget.groupData.startDate,
                  endDate: widget.groupData.endDate,
                  description: widget.groupData.theme,
                ),
                Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedButton(
                        btnText: "지도보기",
                        onPressed: () =>
                            buttonSlideAnimation(context, GroupMap(description: widget.groupData.theme, groupId: widget.groupData.groupId!)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GroupSpendList(groupId: widget.groupData.groupId!),
        ],
      ),
    );
  }
}