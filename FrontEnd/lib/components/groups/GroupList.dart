import "package:flutter/material.dart";
import 'package:front/components/split/SplitDoing.dart';
import 'package:front/screen/SplitMain.dart';
import 'package:front/screen/groupscreens/GroupAdd.dart'; // Group 클래스를 import
import 'package:front/screen/groupscreens/GroupItem.dart';
import 'package:front/components/groups/GroupCard.dart';
import 'package:front/const/colors/Colors.dart';
import '../../entities/Group.dart';
import '../../models/LoadingDialog.dart';
import '../../repository/api/ApiGroup.dart';
import '../split/SplitDone.dart';


class GroupList extends StatefulWidget {
  final List<Group> groups;
  const GroupList({Key? key, required this.groups}) : super(key: key);

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {


  void navigateToGroupAdd() async {
    // Navigator.push()의 결과를 newGroup에 저장
    Group? newGroup = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupAdd()),
    );
    // 결과가 null이 아니면, 새로운 그룹을 목록에 추가
    if (newGroup != null) {
      setState(() {
        widget.groups.add(newGroup);
      });
    }
  }


  void navigateToGroupDetail(Group group) async {
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 다이얼로그 바깥을 탭해도 닫히지 않도록 설정
      builder: (BuildContext context) => const LoadingDialog(),
    );
    String status = await fetchGroupStatus(group.groupId!);
    Navigator.pop(context);

    var modifiedGroup;
    switch (status) {
      case 'before':
        modifiedGroup = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroupItem(groupId: group.groupId!)),
        );
        break;
      case 'ready':
        modifiedGroup = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroupItem(groupId: group.groupId!)),
        );
        break;
      case 'doing':
        modifiedGroup = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroupItem(groupId: group.groupId!)),
        );
        break;
      case 'done':
        modifiedGroup = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroupItem(groupId: group.groupId!)),
        );
        break;
      default:
      // 예외 처리
        break;
    }

    if (modifiedGroup != null) {
      setState(() {
        // 수정된 그룹으로 groups 리스트 업데이트
        int index = widget.groups.indexWhere((g) => g.groupId == modifiedGroup.groupId); // 고유 ID 또는 식별 가능한 속성을 사용
        if (index != -1) {
          widget.groups[index] = modifiedGroup;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.groups.length,
        itemBuilder: (context, index) {
          return GroupCard(
            group: widget.groups[index],
            onTap: () {
              navigateToGroupDetail(widget.groups[index]);
            },
          );
        },
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: navigateToGroupAdd,
        child: Icon(Icons.add, color: Colors.white), // Icon의 color 속성에 Colors.white를 추가
        backgroundColor: BUTTON_COLOR,
      ),
    );
  }

}