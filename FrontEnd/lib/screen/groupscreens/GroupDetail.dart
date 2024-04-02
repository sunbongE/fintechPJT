import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/ProfileChangeBtn.dart';
import '../../entities/Group.dart';
import 'package:front/components/groups/GroupDescription.dart';
import 'package:front/repository/api/ApiGroup.dart';

import '../../models/button/ButtonSlideAnimation.dart';
import '../../repository/api/ApiMyPage.dart';

class GroupDetail extends StatefulWidget {
  final int groupId;

  GroupDetail({required this.groupId});

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  bool iCanOut = false;

  @override
  void initState() {
    checkIsRequest();
    super.initState();
  }

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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('네'),
              onPressed: () async {
                await deleteGroup(group.groupId); // 그룹 삭제 비동기 호출
                buttonSlideAnimationPushAndRemoveUntil(context, 1);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkIsRequest() async {
    Map<String, dynamic> queryParameters = {
      'page': 0,
      'size': 1,
      'option': 'all',
    };
    Response res = await getGroupSpend(widget.groupId, queryParameters);
    setState(() {
      iCanOut = res.data.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Group>(
      future: getGroupDetail(widget.groupId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('데이터를 불러오는데 실패했습니다.')));
        } else if (snapshot.hasData) {
          Group group = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(group.groupName),
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
                        ],
                      ),
                    ),
                  ),
                ),
                if (!iCanOut)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ProfileChangeBtn(
                      onPressed: () => removeGroup(context, group),
                      buttonText: '그룹 삭제하기',
                    ),
                  ),
              ],
            ),
          );
        } else {
          return Scaffold(body: Center(child: Text('데이터가 없습니다.'))); // 데이터가 없을 경우 메시지 표시
        }
      },
    );
  }
}
