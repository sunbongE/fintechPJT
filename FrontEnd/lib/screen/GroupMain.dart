import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupList.dart';


class GroupMain extends StatefulWidget {
  const GroupMain({Key? key}) : super(key: key);

  @override
  State<GroupMain> createState() => _GroupMain();
}

class _GroupMain extends State<GroupMain> {
  String title = "";
  String description = "";
  DateTime? startDate;
  DateTime? endDate;
  int groupState = 0;



  List<Group> groups = [];

  void addGroup(Group group) {
    setState(() {
      groups.add(group);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("그룹 목록"),
      ),
      body: GroupList(),

    );
  }
}
