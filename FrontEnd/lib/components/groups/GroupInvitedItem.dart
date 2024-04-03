import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupJoinMemberCarousel.dart'; // 사용하지 않는 import는 제거하세요.
import 'package:front/entities/GroupMember.dart'; // 사용하지 않는 import는 제거하세요.
import 'package:front/models/button/ButtonSlideAnimation.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:front/repository/api/ApiGroup.dart'; // 사용하지 않는 import는 제거하세요.
import '../../entities/Group.dart'; // 사용하지 않는 import는 제거하세요.

class GroupInvitedItem extends StatefulWidget {
  final int groupId;

  GroupInvitedItem({required this.groupId});

  @override
  _GroupInvitedItemState createState() => _GroupInvitedItemState();
}

class _GroupInvitedItemState extends State<GroupInvitedItem> {
  bool _isPollingActive = false;
  bool isLoading = false;

  @override
  void dispose() {
    _isPollingActive = false;
    super.dispose();
  }

  void groupAgree() async{
    await inviteMemberToGroup(widget.groupId);
    buttonSlideAnimationPushAndRemoveUntil(context, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // 이 Center 위젯은 Scaffold의 body 전체를 가운데 정렬합니다.
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center( // Text 위젯을 가운데 정렬하기 위해 Center 위젯을 사용합니다.
                child: Container(
                  child: Text(
                    '입장하시겠습니까?',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Center( // Row 위젯을 가운데 정렬하기 위해 Center 위젯을 사용합니다.
                child: Container(
                  width: 300.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedButton(
                        size: ButtonSize.m,
                        btnText: '거절하기',
                        onPressed: () {
                          buttonSlideAnimationPushAndRemoveUntil(context, 0);
                        },
                        enable: !_isPollingActive,
                      ),
                      SizedButton(
                        size: ButtonSize.m,
                        btnText: '수락하기',
                        onPressed: () {
                          groupAgree();
                        },
                        enable: !_isPollingActive,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
