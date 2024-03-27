import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupEmailFindField.dart'; // 수정된 import 경로
import '../../entities/GroupMember.dart';
import '../../entities/Group.dart';

void groupInviteByEmail(BuildContext context, Group group) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final _emailController = TextEditingController();
      GroupMember? invitedMember; // 초대하려는 멤버의 정보를 저장할 변수

      return AlertDialog(
        title: Text('인원 추가'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GroupEmailFindField(
                controller: _emailController,
                // onFound: (GroupMember? member) {
                //   invitedMember = member;
                // },
              ),
              // 멤버 정보가 있으면 표시
              // if (invitedMember != null) ...[
              //   Text('이름: ${invitedMember.name}'),
              //   SizedBox(height: 10),
              //   Image.network(invitedMember.thumbnailImage),
              // ]
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('취소'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('초대하기'),
            onPressed: () {
              // if (invitedMember != null) {
              //   // 초대 알림 보내기 로직 구현
              //   print('${invitedMember.name}에게 초대 알림을 보냈습니다.');
              //   Navigator.of(context).pop();
              // }
            },
          ),
        ],
      );
    },
  );
}
