import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupList.dart';
import 'package:front/screen/groupscreens/GroupDetail2.dart';

import '../models/Group.dart';


class GroupMain extends StatefulWidget {
  const GroupMain({Key? key}) : super(key: key);

  @override
  State<GroupMain> createState() => _GroupMain();
}

class _GroupMain extends State<GroupMain> {
  final Map<String, dynamic> rawData = {
    "groups": [
      {
        "title": "긔염둥이들",
        "description": "전주",
        "startDate": "2024-02-04",
        "endDate": "2024-02-07",
        "groupState": false,
        "groupMember": [
          {
            "name": "승혜",
            "email": "123@gmail.com",
          },
          {
            "name": "새로운 멤버1",
            "email": "456@gmail.com",
          },
          {
            "name": "새로운 멤버2",
            "email": "789@gmail.com",
          },
          {
            "name": "새로운 멤버3",
            "email": "111@gmail.com",
          }
        ]
      },
      {
        "title": "고1칭구칭긔",
        "description": "온천",
        "startDate": "2024-04-04",
        "endDate": "2024-04-06",
        "groupState": false,
        "groupMember": [
          {
            "name": "승혜",
            "email": "123@gmail.com",
          },
          {
            "name": "새로운 멤버1",
            "email": "456@gmail.com",
          },
          {
            "name": "새로운 멤버2",
            "email": "789@gmail.com",
          },
          {
            "name": "새로운 멤버3",
            "email": "111@gmail.com",
          }
        ]
      }
    ]
  };

  List<Group> groups = [];

  //그룹 추가
  void addGroup(Group group) {
    setState(() {
      groups.add(group);
    });
  }

  //그룹 삭제
  void removeGroup(String title) {
    setState(() {
      groups.removeWhere((group) => group.title == title);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> groupsJson = rawData['groups'];
    groups = groupsJson.map((groupJson) => Group.fromJson(groupJson)).toList();
    //print(groups.first.groupMembers.elementAt(0).name);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text("그룹 목록"),
      ),
      body: GroupList(groups: groups),

    );
  }
}
