import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/screen/groupscreens/GroupModify.dart';
import '../../entities/Group.dart';
import 'package:front/components/groups/GroupDescription.dart';
import 'package:front/components/groups/MyGroupRequest.dart';

class GroupDetail extends StatelessWidget {
  final Group group;
  final VoidCallback onDelete;

  GroupDetail({required this.group, required this.onDelete});

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
                onDelete(); // 삭제 버튼 클릭시 콜백 함수 호출
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
                    GroupDescription(
                        group: group,
                        onEdit: () {
                          // 수정 로직
                        }),
                    SizedBox(height: 16.0.h),
                    Divider(height: 16.0.h, color: Colors.grey),
                    SizedBox(height: 16.0.h),
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
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: Text('그룹 삭제하기'),
            ),
          ),
        ],
      ),
    );
  }
}
