// import 'package:flutter/material.dart';
// import 'package:front/components/groups/GroupEmailFindField.dart'; // 수정된 import 경로
// import '../../entities/GroupMember.dart';
// import '../../entities/Group.dart';
//
// void groupInviteByEmail(BuildContext context, Group group) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       final _emailController = TextEditingController();
//       List<GroupMember> invitedMembers = []; // 초대하려는 멤버들의 정보를 저장할 리스트
//
//       return AlertDialog(
//         title: Text('인원 추가'),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               GroupEmailFindField(
//                 controller: _emailController,
//                 onFound: (List<GroupMember> members) {
//                   invitedMembers = members; // 멤버 조회 결과 처리
//                   if (invitedMembers.isNotEmpty) {
//                     print(invitedMembers[0]);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text('취소'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           TextButton(
//             child: Text('초대하기'),
//             onPressed: () {
//               // 여기에서 초대 로직을 구현합니다.
//               // 예를 들어, invitedMembers 리스트에 있는 멤버들을 그룹에 초대할 수 있습니다.
//               if (invitedMembers.isNotEmpty) {
//                 print("초대할 멤버: ${invitedMembers[0].name}");
//               }
//               Navigator.of(context).pop(); // 초대 후 대화 상자 닫기
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
