import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupJoinMember.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/screen/MoneyRequest.dart';
import 'package:front/screen/groupscreens/GroupDetail.dart';
import 'package:front/const/colors/Colors.dart';
import '../../entities/Group.dart';
import 'package:email_validator/email_validator.dart';

import '../../models/button/ButtonSlideAnimation.dart';
import '../addreceipt/AddReceipt.dart';

class GroupYesCal extends StatelessWidget {
  final int groupId;

  const GroupYesCal({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 3.w,
            ),
            Text(
              '정산 요청 내역',
              style: TextStyle(
                fontSize: 25.sp,
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
                    minimumSize: Size(90.w, 25.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    '내가 포함된 정산',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: () => buttonSlideAnimation(
                      context,
                      MoneyRequest(
                        groupId: groupId,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BUTTON_COLOR,
                    minimumSize: Size(60.w, 25.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    '추가',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 3.w,
            ),
          ],
        ),
        Text('여기에 정산요청이 들어와요'),
      ],
    );
  }
}
