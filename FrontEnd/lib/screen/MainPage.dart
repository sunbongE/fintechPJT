import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/components/mains/AdCarousel.dart';
import 'package:front/components/mains/AlertList.dart';
import 'package:front/components/mains/MainInfo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mains/MainPastTravel.dart';
import 'package:front/components/mains/MainNowTravel.dart';
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
        groups = (groupsJson.data as List).map((item) => Group.fromJson(item)).toList();
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
          toolbarHeight: 60.0.h,
          title: Padding(
            padding: EdgeInsets.only(left: 16.0.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60.0.w,
                  height: 60.0.h,
                  child: Image.asset('assets/images/orange_logo2.png', fit: BoxFit.contain),
                ),
              ],
            ),
          ),
          // AppBar의 다른 속성들...
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(children: [
            Container(
              height: 100.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyInfoMain(),
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.8.h,
                            child: AlertList(),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20.h),
                        Text("그룹을 불러오고 있습니다"),
                      ],
                    ),
                  )
                : Expanded(
                    child: NowTravelList(groups: groups),
                  ),
            Container(
              height: 170.h,
              child: AdCarousel(),
            ),
            SizedBox(
              height: 30.h,
            ),
            Expanded(
              child: PastTravelList(groups: groups),
            ),
          ]),
        ));
  }
}
