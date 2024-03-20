import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupCard.dart';
import 'package:front/components/mypage/MyTripHistoryDetail.dart';
import '../../entities/Group.dart';
import '../../models/button/ButtonSlideAnimation.dart';

class MyTripHistoryList extends StatefulWidget {
  const MyTripHistoryList({super.key});

  @override
  State<MyTripHistoryList> createState() => _MyTripHistoryListState();
}

class _MyTripHistoryListState extends State<MyTripHistoryList> {
  final Map<String, dynamic> rawData = {
    "groups": [
      {
        "title": "긔염둥이들",
        "description": "전주",
        "startDate": "2024-02-04",
        "endDate": "2024-02-07",
        "groupState": true,
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
        "startDate": "2024-03-15",
        "endDate": "2024-03-22",
        "groupState": true,
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

  void navigateToGroupDetail(Group groupData) {
    buttonSlideAnimation(
      context,
      MyTripHistoryDetail(groupData: groupData),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Group> groups = rawData['groups']
        .map<Group>((groupJson) => Group.fromJson(groupJson))
        .toList();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          '나의 여정 기록',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.w),
        child: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            return GroupCard(
              group: groups[index],
              onTap: () {
                navigateToGroupDetail(groups[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
