import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/MyTripHistoryList.dart';
import 'package:lottie/lottie.dart';
import '../../entities/Group.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../repository/api/ApiGroup.dart';
import '../groups/GroupCard.dart';
import 'MyTripHistoryDetail.dart';

class MyTripHistory extends StatefulWidget {
  const MyTripHistory({super.key});

  @override
  State<MyTripHistory> createState() => _MyTripHistoryState();
}

class _MyTripHistoryState extends State<MyTripHistory> {
  bool isLoading = false;
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  void fetchGroups() async {
    setState(() {
      isLoading = true;
    });
    var groupsJson = await getGroupList();
    if (groupsJson != null && groupsJson.data is List) {
      setState(() {
        groups = (groupsJson.data as List).map((item) => Group.fromJson(item)).where((group) => group.isCalculateDone!).toList();
        groups.sort((a, b) => b.endDate.compareTo(a.endDate));

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("그룹 데이터를 불러오는 데 실패했습니다.");
    }
  }

  void navigateToGroupDetail(Group groupData) {
    buttonSlideAnimation(
      context,
      MyTripHistoryDetail(groupData: groupData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "나의 여정 기록",
            style: TextStyle(fontSize: 20.sp),
          ),
          isLoading
              ? Center(child: Lottie.asset('assets/lotties/orangewalking.json'))
              : ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: groups.length > 3 ? 3 : groups.length,
                  itemBuilder: (context, index) {
                    return GroupCard(
                      group: groups[index],
                      onTap: () {
                        navigateToGroupDetail(groups[index]);
                      },
                    );
                  },
                ),
          TextButton(
            onPressed: () {
              buttonSlideAnimation(context, MyTripHistoryList());
            },
            child: Text("더 보기"),
          ),
        ],
      ),
    );
  }
}
