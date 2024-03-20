import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/MyTripHistoryDetail.dart';

import '../../const/colors/Colors.dart';

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
        "startDate": "2024-04-04",
        "endDate": "2024-04-06",
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

  void navigateToGroupDetail(Map<String, dynamic> groupData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyTripHistoryDetail(groupData: groupData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> groups = rawData['groups'];
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          '나의 여정 기록',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            // 컴포넌트 받아오기
            return Card(
              margin: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: COMPLETE_COLOR,
              child: ListTile(
                onTap: () => navigateToGroupDetail(groups[index]),
                title: Text(
                  groups[index]['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(groups[index]['description']),
                    Text('시작일: ${groups[index]['startDate']}'),
                    Text('종료일: ${groups[index]['endDate']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}