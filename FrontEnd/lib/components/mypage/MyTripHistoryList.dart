import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupCard.dart';
import 'package:front/components/mypage/MyTripHistoryDetail.dart';
import '../../entities/Group.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../repository/api/ApiGroup.dart';

class MyTripHistoryList extends StatefulWidget {
  const MyTripHistoryList({super.key});

  @override
  State<MyTripHistoryList> createState() => _MyTripHistoryListState();
}

class _MyTripHistoryListState extends State<MyTripHistoryList> {
  List<Group> groups = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  void navigateToGroupDetail(Group groupData) {
    buttonSlideAnimation(
      context,
      MyTripHistoryDetail(groupData: groupData),
    );
  }

  // 더미데이터 코드
  void fetchGroups() async {
    setState(() {
      isLoading = true;
    });

    final List<dynamic> dummyData = [
      {
        "groupId": 1,
        "groupName": "그루비룸",
        "startDate": "2024-03-21",
        "endDate": "2024-03-21",
        "theme": "여행 테마",
        "isCalculateDone": false
      },
      {
        "groupId": 2,
        "groupName": "그루비룸2",
        "startDate": "2024-03-21",
        "endDate": "2024-03-21",
        "theme": "여행 테마",
        "isCalculateDone": true,
      },
      {
        "groupId": 7,
        "groupName": "그루비룸9911",
        "startDate": "2024-03-21",
        "endDate": "2024-03-21",
        "theme": "여행 테마",
        "isCalculateDone": false
      },
      {
        "groupId": 8,
        "groupName": "그룹ㄱ생성ㅌ체스트1",
        "startDate": "2024-03-21",
        "endDate": "2024-03-21",
        "theme": "여행 테마",
        "isCalculateDone": true,
      },
      {
        "groupId": 9,
        "groupName": "그루비룸",
        "startDate": "2024-03-22",
        "endDate": "2024-03-22",
        "theme": "여행 테마",
        "isCalculateDone": false
      },
      {
        "groupId": 10,
        "groupName": "녕뇽냥늉",
        "startDate": "2024-03-22",
        "endDate": "2024-03-22",
        "theme": "여행 테마",
        "isCalculateDone": true,
      },
      {
        "groupId": 20,
        "groupName": "그루비룸",
        "startDate": "2024-03-22",
        "endDate": "2024-03-22",
        "theme": "여행 테마",
        "isCalculateDone": true,
      },
      {
        "groupId": 21,
        "groupName": "ㅎㅇㅎㅇ",
        "startDate": "2024-03-22",
        "endDate": "2024-03-22",
        "theme": "여행 테마",
        "isCalculateDone": true,
      },
      {
        "groupId": 22,
        "groupName": "도저언",
        "startDate": "2024-03-22",
        "endDate": "2024-03-22",
        "theme": "여행 갈랭",
        "isCalculateDone": true,
      },
      {
        "groupId": 26,
        "groupName": "ㄷㅂㄷㅂ",
        "startDate": "2024-03-25",
        "endDate": "2024-03-30",
        "theme": "ㅈㅂㅈㅂ",
        "isCalculateDone": false,
      },
      {
        "groupId": 31,
        "groupName": "theme왜",
        "startDate": "2024-03-24",
        "endDate": "2024-03-24",
        "theme": "나와라잇",
        "isCalculateDone": true,
      }
    ];
    setState(() {
      groups = dummyData.map((item) => Group.fromJson(item as Map<String, dynamic>)).where((group) => group.isCalculateDone ?? false).toList();
      isLoading = false;
    });
  }
  // 찐 코드
  // void fetchGroups() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final groupsJson = await getGroupList();
  //   if (groupsJson != null && groupsJson.data is List) {
  //     setState(() {
  //       groups = (groupsJson.data as List).map((item) => Group.fromJson(item)).where((group) => group.isCalculateDone ?? false).toList();
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print("그룹 데이터를 불러오는 데 실패했습니다.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
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
