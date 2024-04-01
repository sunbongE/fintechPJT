import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupJoinMember.dart';
import 'package:front/components/groups/GroupJoinMemberCarousel.dart';
import 'package:front/components/groups/GroupNoCal.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/entities/GroupMember.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:front/repository/api/ApiGroup.dart';
import 'package:front/screen/SplitMain.dart';
import 'package:front/screen/groupscreens/GroupDetail.dart';
import '../../entities/Group.dart';
import '../../repository/api/ApiSplit.dart';

class GroupInvitedItem extends StatefulWidget {
  final int groupId;

  GroupInvitedItem({required this.groupId});

  @override
  _GroupInvitedItemState createState() => _GroupInvitedItemState();
}

class _GroupInvitedItemState extends State<GroupInvitedItem> {
  bool _isPollingActive = false;
  List<GroupMember> members = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  void fetchMembers() async {
    setState(() {
      isLoading = true;
    });
    final groupMembersJson = await getGroupMemberList(widget.groupId);
    if (groupMembersJson != null) {
      setState(() {
        members = (groupMembersJson.data['groupMembersDtos'] as List).map((item) => GroupMember.fromJson(item)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("그룹 데이터를 불러오는 데 실패했습니다.");
    }
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GroupJoinMemberCarousel(members: members),
                      Container(
                        width: 200.w,
                        height: 190.h,
                        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                group.groupName,
                                style: TextStyle(
                                  fontSize: 35.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                '의 여정에',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            '입장하시겠습니까?',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        width: 300.w,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedButton(
                              size: ButtonSize.m,
                              btnText: '거절하기',
                              onPressed: () {
                                buttonSlideAnimationPushAndRemoveUntil(context, 0);
                              },
                              enable: !_isPollingActive,
                            ),
                            SizedButton(
                              size: ButtonSize.m,
                              btnText: '수락하기',
                              onPressed: () {
                                inviteMemberToGroup(widget.groupId);
                                buttonSlideAnimationPushAndRemoveUntil(context, 1);
                              },
                              enable: !_isPollingActive,
                            ),
                          ],
                        ),
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
