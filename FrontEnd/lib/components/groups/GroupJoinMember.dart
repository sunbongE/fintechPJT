import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupJoinMemberCarousel.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:lottie/lottie.dart';
import '../../entities/Group.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';
import 'package:front/entities/GroupMember.dart';
import 'package:front/repository/api/ApiGroup.dart';
import 'package:front/components/groups/GroupInviteByEmail.dart';

class GroupJoinMember extends StatefulWidget {
  final Group group;

  const GroupJoinMember({Key? key, required this.group}) : super(key: key);

  @override
  _GroupJoinMemberState createState() => _GroupJoinMemberState();
}

class _GroupJoinMemberState extends State<GroupJoinMember> {
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
    final groupMembersJson = await getGroupMemberList(widget.group.groupId);
    if (groupMembersJson != null) {
      setState(() {
        members = (groupMembersJson.data['groupMembersDtos'] as List)
            .map((item) => GroupMember.fromJson(item))
            .toList();
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
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => groupInviteByEmail(context, widget.group),
              ),
            ],
          ),
          isLoading // isLoading의 상태에 따라 다른 위젯을 표시
              ? Center(
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                          'assets/lotties/orangewalking.json',
                        width: 90.w,
                        height: 90.h,
                      ),
                      Text("멤버를 불러오고 있습니다"),
                    ],
                  ),
                )
              : GroupJoinMemberCarousel(members: members),
        ],
      ),
    );
  }
}
