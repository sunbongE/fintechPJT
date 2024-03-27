import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupList.dart';
import 'package:front/screen/groupscreens/GroupAdd.dart';
import 'package:front/models/button/GroupAddButton2.dart';
import '../entities/Group.dart';
import 'package:front/repository/api/ApiGroup.dart';

class GroupMain extends StatefulWidget {
  const GroupMain({Key? key}) : super(key: key);

  @override
  State<GroupMain> createState() => _GroupMainState();
}

class _GroupMainState extends State<GroupMain> {
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

  void navigateToGroupAdd() async {
    final Group? newGroup = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupAdd()),
    );

    if (newGroup != null) {
      setState(() {
        groups.add(newGroup);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "그룹 목록",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/orangewalking.json'),
                  SizedBox(height: 20.h),
                  Text("그룹을 불러오고 있습니다"),
                ],
              ),
            )
          : groups.isEmpty
              ? Center(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty.png',
                      width: 250.w,
                      height: 200.h,
                    ),
                    Text(
                      '아직 시작한 여행이 없네요',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '여행을 등록해볼까요?',
                      style: TextStyle(
                        fontSize: 30.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.0.h),
                    GroupAddButton2(
                      onPressed: navigateToGroupAdd,
                      btnText: '등록하기',
                    )
                  ],
                ))
              : GroupList(groups: groups),
    );
  }
}
