import "package:flutter/material.dart";
import 'package:front/screen/groupscreens/GroupAdd.dart'; // Group 클래스를 import
import 'package:front/screen/groupscreens/GroupItem.dart';
import 'package:front/components/groups/GroupCard.dart';

import '../../entities/Group.dart';


class GroupList extends StatefulWidget {
  final List<Group> groups;
  const GroupList({Key? key, required this.groups}) : super(key: key);

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {


  void navigateToGroupAdd() async {
    Group newGroup = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupAdd()),
    );
    if (newGroup != null) {
      setState(() {
        widget.groups.add(newGroup);
      });
    }
  }

  void navigateToGroupDetail(Group group) async {
    final modifiedGroup = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupItem(group: group)),
    );

    if (modifiedGroup != null) {
      setState(() {
        // 수정된 그룹으로 groups 리스트 업데이트
        int index = widget.groups.indexWhere((g) => g.title == modifiedGroup.title); // 고유 ID 또는 식별 가능한 속성을 사용
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

      floatingActionButton: ElevatedButton(
        onPressed: navigateToGroupAdd,
        child: Icon(Icons.add),
      ),
    );
  }
}