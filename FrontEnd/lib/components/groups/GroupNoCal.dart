import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupJoinMember.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/screen/groupscreens/GroupDetail.dart';
import 'package:front/const/colors/Colors.dart';
import '../../entities/Group.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';

import '../../models/button/ButtonSlideAnimation.dart';
import '../../screen/MoneyRequest.dart';

class GroupNoCal extends StatelessWidget {
  const GroupNoCal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 130.h,
          width: 300.w,
          child: Card(
            color: BUTTON_COLOR,
            child: Column(
              children: [
                SizedBox(height: 16.0.h),
                Text(
                  '여행이 끝나지 않아도',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '정산요청을 할 수 있어요',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0.h),
                ElevatedButton(
                  onPressed: () => buttonSlideAnimation(context, MoneyRequest(groupId: 1,)),//임시로 1로 썼습니다 -지연
                  style: ElevatedButton.styleFrom(
                    backgroundColor: STATE_COLOR,
                    textStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    '요청하기',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
