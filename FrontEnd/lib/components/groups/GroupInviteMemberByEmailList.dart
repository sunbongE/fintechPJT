// import 'package:flutter/material.dart';
// import 'package:front/components/groups/GroupJoinMemberCard.dart';
// import 'package:front/entities/Member.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class GroupInviteMemberList extends StatefulWidget {
//   final List<Member> members;
//
//   const GroupInviteMemberList({Key? key, required this.members})
//       : super(key: key);
//
//   @override
//   State<GroupInviteMemberList> createState() =>
//       _GroupInviteMemberListState();
// }
//
// class _GroupInviteMemberListState extends State<GroupInviteMemberList> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120.h,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: widget.members.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: MediaQuery.of(context).size.width * 0.15,
//             margin: EdgeInsets.symmetric(horizontal: 5.0), // 좌우 마진 설정
//             child: GroupJoinMemberCard(member: widget.members[index]), // 멤버 카드 위젯 사용
//           );
//         },
//       ),
//     );
//   }
// }