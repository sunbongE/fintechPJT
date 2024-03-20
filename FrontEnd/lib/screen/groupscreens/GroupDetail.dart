import 'package:flutter/material.dart';
import '../../models/Group.dart';
import 'package:front/components/groups/GroupDecription.dart';
import 'package:front/components/groups/MyGroupRequest.dart';

class GroupDetail2 extends StatelessWidget {
  final Group group;

  GroupDetail2({required this.group});

  void removeGroup(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('그룹 삭제'),
          content: Text('정말로 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
            ),
            TextButton(
              child: Text('네'),
              onPressed: () {
                // 여기에 그룹 삭제 로직을 구현
                Navigator.of(context).pop(); // 모달 닫기
                Navigator.of(context).pop(); // Detail2 닫기
                Navigator.of(context).pop(); // Detail 닫기
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GroupDecription(group: group, onEdit: () {
                      // 수정 로직
                    }),
                    SizedBox(height: 16.0),
                    Divider(height: 16.0, color: Colors.grey),
                    SizedBox(height: 16.0),
                    MyGroupRequest(requestDetails: '정보들'),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () => removeGroup(context, group),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('그룹 삭제하기'),
            ),
          ),
        ],
      ),
    );
  }
}
