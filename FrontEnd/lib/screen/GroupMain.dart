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
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  void fetchGroups() async {
    final groupsJson = await getGroupList();
    if (groupsJson != null && groupsJson.data is List) {
      setState(() {
        groups = (groupsJson.data as List)
            .map((item) => Group.fromJson(item))
            .toList();
      });
    } else {
      print("그룹 데이터를 불러오는 데 실패했습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('그룹 목록'),
      ),
      body: GroupList(groups: groups),  // 수정된 부분: GroupList 위젯에 그룹 데이터 리스트를 전달
    );
  }
}


// class _GroupMain extends State<GroupMain> {
//   List<Group> groups = [];
//   //
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   fetchGroups();
//   // }
//   //
//   // void fetchGroups() async {
//   //   final groupsJson = await getGroupList();
//   //   if (groupsJson != null && groupsJson.data is List) {
//   //     List<Group> groups = (groupsJson.data as List)
//   //         .map((item) => Group.fromJson(item))
//   //         .toList();
//   //     print(1111111);
//   //     print(groupsJson.data);
//   //   } else {
//   //     print("그룹업성");
//   //   }
//   // }
//
//   // void fetchGroups() async {
//   //   final groupsJson = await getGroupList();
//   //   if (groupsJson != null && groupsJson.data is List) {
//   //
//   //     // print(1111111);
//   //     // print(groupsJson.data);
//   //     // print(1111111);
//   //     // final List<Group> loadedGroups = (groupsJson.data as List)
//   //     //     .map((groupJson) => Group.fromJson(groupJson))
//   //     //     .toList();
//   //
//   //     print(1111111);
//   //     groups = groupsJson.data;
//   //     print(222222);
//   //     print(groups);
//   //
//   //     //
//   //     // setState(() {
//   //     //   groups = groupsJson.data;
//   //     //   print(1111111);
//   //     //   print(groups);
//   //     // });
//   //   }
//   //   else {
//   //     print("그룹업성");
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
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
