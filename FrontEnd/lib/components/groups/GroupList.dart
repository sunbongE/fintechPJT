import "package:flutter/material.dart";
import 'package:front/const/colors/Colors.dart';
import 'package:front/screen/groupscreens/GroupAdd.dart'; // Group 클래스를 import
import 'package:front/screen/groupscreens/GroupItem.dart';
import 'package:front/components/groups/GroupCard.dart';

import '../../models/Group.dart';

//백에서 group정보 받아오면 여기에 넣기

class GroupList extends StatefulWidget {
  final List<Group> groups;
  //final List<Group> groups;
  const GroupList({Key? key, required this.groups}) : super(key: key);


  // static List<Group> getGroups(BuildContext context) {
  //   final _GroupListState state = context.findAncestorStateOfType<_GroupListState>()!;
  //   return state.groups;
  // }
  // static void setGroups(BuildContext context, List<Group> updatedGroup) {
  //   final _GroupListState state = context.findAncestorStateOfType<_GroupListState>()!;
  //     state.groups = updatedGroup;
  // }


  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {

  //List<Group> groups = [];

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

  void navigateToGroupDetail(Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupDetail(group: group)),
    );
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