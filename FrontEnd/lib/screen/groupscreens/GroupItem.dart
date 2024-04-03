import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupCalCheck.dart';
import 'package:front/components/groups/GroupJoinMember.dart';
import 'package:front/entities/GroupMember.dart';
import 'package:front/models/button/GroupAddButton2.dart';
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
  List<GroupMember> members = [];
  bool _isPollingActive = false;

  Future<bool> checkPersonalStatus() async {
    final bool res = await getisSplit(widget.groupId);
    setState(() {
      _isPollingActive = res;
    });
    return true;
  }
 void pollingForGroupMemberStatus() async {
    print('----들어와짐?');
    print(_isPollingActive);
   while (_isPollingActive) {
     String status = await fetchGroupMemberStatus(widget.groupId);
     print('--------------------폴링중');
     if (status == "SPLIT") {
       Navigator.push(
         context,
         MaterialPageRoute(
             builder: (context) => SplitMain(
               groupId: widget.groupId,
             )),
       );
       break;
     }
     await Future.delayed(Duration(seconds: 3));
   }
  print('빠져나감');
 }

  void handleSettleButtonPressed() async {
    await putFirstCall(widget.groupId);
    setState(() {
      _isPollingActive = !_isPollingActive;
    });
    pollingForGroupMemberStatus();
  }
  Future<void> initializeAsyncTasks() async {
    await checkPersonalStatus();
    pollingForGroupMemberStatus();
  }

  @override
  void initState() {
    initializeAsyncTasks();
    super.initState();
    fetchMembers();
  }
  @override
  void dispose() {
    // 폴링 상태를 비활성화하여 폴링 루프를 중단
    _isPollingActive = false;
    super.dispose();
  }

  void fetchMembers() async {
    final groupMembersJson = await getGroupMemberList(widget.groupId);
    if (groupMembersJson != null) {
      setState(() {
        members = (groupMembersJson.data['groupMembersDtos'] as List)
            .map((item) => GroupMember.fromJson(item))
            .toList();
      });
    } else {
      setState(() {
      });
      print("그룹 데이터를 불러오는 데 실패했습니다.");
    }
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
                      members.length > 1 ? GroupAddButton2(
                        btnText: !_isPollingActive ? '정산하기' : '취소하기',
                        onPressed: () {
                          handleSettleButtonPressed();
                        },
                      ) : Container(), // members.length가 1 이하일 경우 아무것도 표시하지 않음

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
