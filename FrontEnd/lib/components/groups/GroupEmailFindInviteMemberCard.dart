import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';
import '../../entities/GroupMember.dart';

class GroupEmailFindInviteMemberCard extends StatelessWidget {
  final member;

  const GroupEmailFindInviteMemberCard({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8.h),
        Stack(
          clipBehavior: Clip.none, // 자식이 Stack 바깥으로 벗어나도록 허용
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(member['thumbnailImage']),
              radius: 30.r, // 원하는 반지름 설정, 스크린 사이즈에 따라 조정 가능
            ),
            Positioned(
              right: -6.r, // 오른쪽 상단에 위치시키기 위해 적절히 조정
              top: -6.r, // 상단에 위치시키기 위해 적절히 조정
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey, // X표시 배경색
                  shape: BoxShape.circle, // 원형으로 만들기
                ),
                child: Icon(
                  Icons.close, // X 아이콘
                  size: 16.r, // 아이콘 사이즈 조정
                  color: Colors.white, // 아이콘 색상
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h), // 이미지와 텍스트 사이의 간격 설정
        Text(member['name']), // 멤버 이름 표시
      ],
    );
  }
}
