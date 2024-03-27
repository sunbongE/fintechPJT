import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupCard.dart';
import 'package:front/components/mypage/MyTripHistoryDetail.dart';
import 'package:lottie/lottie.dart';
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

  void fetchGroups() async {
    setState(() {
      isLoading = true;
    });
    var groupsJson = await getGroupList();
    if (groupsJson != null && groupsJson.data is List) {
      setState(() {
        // 이게 진짜코드임~~ 무조건 변경해야함.
        // groups = (groupsJson.data as List).map((item) => Group.fromJson(item)).where((group) => group.isCalculateDone!).toList();
        groups = (groupsJson.data as List).map((item) => Group.fromJson(item)).where((group) => !group.isCalculateDone!).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("그룹 데이터를 불러오는 데 실패했습니다.");
    }
  }

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
            ? Center(child: Lottie.asset('assets/lotties/orangewalking.json'))
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
