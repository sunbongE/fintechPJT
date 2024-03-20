import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupMember.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/screen/groupscreens/GroupDetail.dart';
import 'package:front/const/colors/Colors.dart';
import '../../models/Group.dart';
import 'package:email_validator/email_validator.dart';

class GroupYesCal extends StatelessWidget {
  const GroupYesCal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '내가 내야 할 것',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                // 내가 내야 할 것 버튼 클릭 시 동작할 코드
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BUTTON_COLOR,
                minimumSize: Size(140, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                '내가 내야 할 것',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // 추가 버튼 클릭 시 동작할 코드
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BUTTON_COLOR,
                minimumSize: Size(100, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                '추가',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}