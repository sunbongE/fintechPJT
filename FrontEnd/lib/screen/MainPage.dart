import 'package:flutter/material.dart';
import 'package:front/components/mains/AlertList.dart';
import 'package:front/components/mains/MainInfo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mains/MainPastTravel.dart';
import 'package:front/components/mains/MainNowTravel.dart';
import 'package:lottie/lottie.dart';
import '../entities/Group.dart';
import 'package:front/repository/api/ApiGroup.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Group> groups = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  void fetchGroups() async {
    setState(() {
      isLoading = true;
    });
    final groupsJson = await getGroupList();
    if (groupsJson != null && groupsJson.data is List) {
      setState(() {
        groups = (groupsJson.data as List)
            .map((item) => Group.fromJson(item))
            .toList();
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
        ),
        body: Column(children: [
          Container(
            height: 100.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyInfoMain(),
                IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AlertList()),
                    );
                  },
                ),
              ],
            ),
          ),
          // if (groups.isEmpty) // isLoading 대신 groups.isEmpty 조건을 사용합니다.
          //   Expanded(
          //     child: Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //   )
          // else ...[
          isLoading?
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20.h),
                Text("그룹을 불러오고 있습니다"),
              ],
            ),
          ) :
            Expanded(
              child: NowTravelList(groups: groups),
            ),
            Expanded(
              child: PastTravelList(groups: groups),
            ),
          // ],
        ]
        )
    );
  }
}
