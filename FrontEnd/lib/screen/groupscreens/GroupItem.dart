import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupJoinMember.dart';
import 'package:front/components/groups/GroupYesCal.dart';
import 'package:front/components/groups/GroupNoCal.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/repository/api/ApiGroup.dart';
import 'package:front/screen/groupscreens/GroupDetail.dart';
import '../../entities/Group.dart';

class GroupItem extends StatelessWidget {
  final int groupId;

  GroupItem({required this.groupId});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: FutureBuilder<Group>(
          future: getGroupDetail(groupId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.groupName);
              } else if (snapshot.hasError) {
                return Text('그룹 정보 조회 실패');
              }
            }
            // 데이터 로딩 중이면 로딩 인디케이터 표시
            return CircularProgressIndicator();
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetail(
                    groupId: groupId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Group>(
        future: getGroupDetail(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final group = snapshot.data!;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Container(
                        constraints: BoxConstraints(minHeight: 150.h),
                        child: SizedBox(
                          child: GroupJoinMember(group: group),
                        ),
                      ),
                      // 정산하기 버튼
                      Button(
                        btnText: '정산하기',
                        onPressed: () {},
                      ),
                      //정산요청 내역이 있으면
                      // 정산 요청 내역
                      GroupYesCal(
                        groupId: group.groupId ?? 0,
                      ),
                      // 내가 포함된 내역 필터링 버튼
                      // 정산 요청 추가하기 버튼
                      //정산 요청 내역이 없으면
                      GroupNoCal(
                        groupId: group.groupId ?? 0,
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('그룹 정보를 불러올 수 없습니다.'));
            }
          }
          return Center(child: CircularProgressIndicator()); // 데이터 로딩 중
        },
      ),
    );
  }
}
