import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupList.dart';

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
        "title": "그룹 1",
        "description": "그룹 1 설명",
        "startDate": "2022-01-01",
        "endDate": "2022-01-10",
        "groupState": false,
        "groupMember": [
          {
            "name": "승혜"
          },
          {
            "name": "새로운 멤버1"
          },
          {
            "name": "새로운 멤버2"
          },
          {
            "name": "새로운 멤버3"
          }
        ]
      },
      {
        "title": "그룹 2",
        "description": "그룹 2 설명",
        "startDate": "2022-02-01",
        "endDate": "2022-02-10",
        "groupState": true,
        "groupMember": [
          {
            "name": "승혜"
          },
          {
            "name": "새로운 멤버1"
          },
          {
            "name": "새로운 멤버2"
          },
          {
            "name": "새로운 멤버3"
          }
        ]
      }
    ]
  };



  List<Group> groups = [];

  void addGroup(Group group) {
    setState(() {
      groups.add(group);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> groupsJson = rawData['groups'];
    groups = groupsJson.map((groupJson) => Group.fromJson(groupJson)).toList();
    //print(groups.first.groupMembers.elementAt(0).name);
    return Scaffold(
      appBar: AppBar(
        title: Text("그룹 목록"),
      ),
      body: GroupList(groups: groups),

    );
  }
}
