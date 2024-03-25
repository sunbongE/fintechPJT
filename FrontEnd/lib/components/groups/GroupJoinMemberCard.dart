import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';
import '../../entities/GroupMember.dart';

class GroupJoinMemberCard extends StatelessWidget {
  final GroupMember member;

  const GroupJoinMemberCard({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(member.thumbnailImage),
          radius: 30.r, // 원하는 반지름 설정, 스크린 사이즈에 따라 조정 가능
        ),
        SizedBox(height: 8.h), // 이미지와 텍스트 사이의 간격 설정

        Text(member.name), // 멤버 이름 표시
      ],
    );
  }
}