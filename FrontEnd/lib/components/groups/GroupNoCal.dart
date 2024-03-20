import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupMember.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/screen/groupscreens/GroupDetail.dart';
import 'package:front/const/colors/Colors.dart';
import '../../entities/Group.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';

class GroupNoCal extends StatelessWidget {
  const GroupNoCal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 130,
          width: 300,
          child: Card(
            color: BUTTON_COLOR,
            child: Column(
              children: [
                SizedBox(height: 16.0),
                Text(
                  '여행이 끝나지 않아도',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '정산요청을 할 수 있어요',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    // 요청하기 버튼 클릭 시 동작할 코드
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: STATE_COLOR,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    '요청하기',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Image.asset(
          'assets/images/empty.png',
          width: 250,
          height: 200,
        ),
        SizedBox(height: 6.0),
        Text(
          '정산 요청이 비어있어요',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
