import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupList.dart';
import 'package:front/screen/groupscreens/GroupDetail.dart';
import 'package:front/screen/groupscreens/GroupModify.dart';

import '../../models/Group.dart';


class GroupDetail2 extends StatelessWidget {
  final Group group;

  GroupDetail2({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupDetail(group: group),
                    ),
                  );                },
                child: Text('그룹 정보 수정'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 내가 요청한 정산 내역 보기 버튼 동작
                },
                child: Text('내가 요청한 정산 내역'),
              ),
              ElevatedButton(
                onPressed: () {
                  // 그룹 나가기 버튼 동작
                },
                child: Text('그룹 나가기'),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
