import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupJoinMemberCard.dart';
import 'package:front/entities/GroupMember.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupJoinMemberCarousel extends StatefulWidget {
  final List<GroupMember> members;

  const GroupJoinMemberCarousel({Key? key, required this.members})
      : super(key: key);

  @override
  State<GroupJoinMemberCarousel> createState() =>
      _GroupJoinMemberCarouselState();
}

class _GroupJoinMemberCarouselState extends State<GroupJoinMemberCarousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.members.length,
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.15,
            margin: EdgeInsets.symmetric(horizontal: 5.0), // 좌우 마진 설정
            child: GroupJoinMemberCard(member: widget.members[index]), // 멤버 카드 위젯 사용
          );
        },
      ),
    );
  }
}