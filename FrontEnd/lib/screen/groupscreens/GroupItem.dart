import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupCalCheck.dart';
import 'package:front/components/groups/GroupJoinMember.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:front/repository/api/ApiGroup.dart';
import 'package:front/screen/groupscreens/GroupDetail.dart';
import '../../entities/Group.dart';
import '../../repository/api/ApiSplit.dart';
import '../SplitMain.dart';

class GroupItem extends StatefulWidget {
  final int groupId;

  GroupItem({required this.groupId});

  @override
  _GroupItemState createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> {
  bool _isPollingActive = false;

  // 정산하기 버튼을 눌렀을 때의 동작을 처리하는 함수
  void handleSettleButtonPressed() async {
    bool firstCallResult = await putFirstCall(widget.groupId);
    String status = await fetchGroupMemberStatus(widget.groupId);
    setState(() {
      _isPollingActive = true;
    });
    while (_isPollingActive) {
      await Future.delayed(Duration(seconds: 15));
      status = await fetchGroupMemberStatus(widget.groupId);
      print('--------------------현재 상태');
      if (status == "SPLIT") {
        break;
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SplitMain(
                groupId: widget.groupId,
              )),
    );
  }

  @override
  void dispose() {
    _isPollingActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: FutureBuilder<Group>(
          future: getGroupDetail(widget.groupId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.groupName);
              } else if (snapshot.hasError) {
                return Text('그룹 정보 조회 실패');
              }
            }
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
                    groupId: widget.groupId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Group>(
        future: getGroupDetail(widget.groupId),
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
                      SizedButton(
                        size: ButtonSize.l,
                        btnText: !_isPollingActive ? '정산하기' : '대기중',
                        onPressed: () {
                          handleSettleButtonPressed();
                        },
                        enable: !_isPollingActive,
                      ),
                      // 정산요청 내역이 있으면
                      // 정산 요청 내역
                      GroupCalCheck(
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
