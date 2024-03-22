import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupList.dart';
import '../entities/Group.dart';
import 'package:front/repository/api/ApiGroup.dart';

class GroupMain extends StatefulWidget {
  const GroupMain({Key? key}) : super(key: key);

  @override
  State<GroupMain> createState() => _GroupMain();
}

class _GroupMain extends State<GroupMain> {
  List<Group>? groups = [];

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  void fetchGroups() async {
    final groupsJson = await getGroupList();
    if (groupsJson != null && groupsJson.data is List) {
      final List<Group> loadedGroups = (groupsJson.data as List)
          .map((groupJson) => Group.fromJson(groupJson))
          .toList();
      setState(() {
        groups = loadedGroups;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text("그룹 목록"),
      ),
      body: groups == null
          ? Center(child: Text('그룹이 없습니다'))
          : GroupList(groups: groups!),
    );
  }
}

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:front/components/groups/GroupList.dart';
// import '../entities/Group.dart';
// import 'package:front/repository/api/ApiGroup.dart';
//
// class GroupMain extends StatefulWidget {
//   const GroupMain({Key? key}) : super(key: key);
//
//   @override
//   State<GroupMain> createState() => _GroupMain();
// }
//
// class _GroupMain extends State<GroupMain> {
//   List<Group> groups = [];
//   Response? groupsJson;
//
//   @override
//   void initState() {
//     super.initState();
//     groupsJson = getGroupList();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     groups = groupsJson.map((groupJson) => Group.fromJson(groupJson)).toList();
//     //print(groups.first.groupMembers.elementAt(0).name);
//     return Scaffold(
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         title: Text("그룹 목록"),
//       ),
//       body: GroupList(groups: groups),
//
//     );
//   }
// }
