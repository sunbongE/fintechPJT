import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupJoinMember.dart';
import 'package:front/components/mypage/GroupSpendList.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/screen/MoneyRequest.dart';
import 'package:front/screen/groupscreens/GroupDetail.dart';
import 'package:front/const/colors/Colors.dart';
import '../../entities/Group.dart';
import '../../models/button/ButtonSlideAnimation.dart';

class GroupYesCal extends StatelessWidget {
  final int groupId;

  const GroupYesCal({Key? key, required this.groupId}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 350.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                '정산 요청 내역',
                style: TextStyle(
                  fontSize: min(15.sp, 15.sp),
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 내가 포함된 정산 버튼 클릭 시 동작할 코드
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BUTTON_COLOR,
                      minimumSize: Size(40.w, 30.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      '내가 포함된 정산',
                      style: TextStyle(
                        fontSize: min(15.sp, 15.sp),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  ElevatedButton(
                    onPressed: () => buttonSlideAnimation(
                        context,
                        MoneyRequest(
                          groupId: groupId,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BUTTON_COLOR,
                      minimumSize: Size(20.w, 30.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      '+',
                      style: TextStyle(
                        fontSize: min(15.sp, 15.sp),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(

        ),
      ],
    );
  }
}
