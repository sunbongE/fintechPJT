
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/split/SplitMembers.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:lottie/lottie.dart';

import '../../entities/SplitDoingResponse.dart';
import '../../repository/api/ApiGroup.dart';
import '../../repository/api/ApiSplit.dart';
import 'SplitLoading.dart';

class SplitDoing extends StatefulWidget {
  final groupId;
  const SplitDoing({super.key, this.groupId});

  @override
  State<SplitDoing> createState() => _SplitDoingState();
}

class _SplitDoingState extends State<SplitDoing> {
  List<SplitDoingResponse> doingMember = [];
  bool _isPollingActive = true;
  @override
  void initState() {
    super.initState();
    fetchGroupMemberList();
    checkGroupStatusAndNavigate();


  }
  void fetchGroupMemberList() async {
    final groupMemberResponse = await getGroupMemberList(widget.groupId);
    final groupMembers =
    groupMemberResponse.data['groupMembersDtos'] as List<dynamic>;
    setState(() {
      doingMember = groupMembers
          .map((memberJson) => SplitDoingResponse.fromJson(memberJson))
          .toList();
    });
    fetchSecondCallMembersAndUpdateReadyStatus();
  }

  void fetchSecondCallMembersAndUpdateReadyStatus() async {
    print('세컨드콜 누른사람 목록 받아옴');
      final res = await getSecondCallMember(widget.groupId);
      final List<dynamic> secondCallMembers = res.data;
      setState(() {
        for (var member in doingMember) {
          if (secondCallMembers.any((m) => m['kakaoId'] == member.kakaoId)) {
            member.isReady = true;
          }
        }
      });
  }

  void checkGroupStatusAndNavigate() async {

    while (_isPollingActive) {
      print('폴링중~~~~');
      final res = await getPersonalGroupStatus(widget.groupId);
      print(res);
      if (res == 'DONE') {
        _isPollingActive = false;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplitLoading(groupId: widget.groupId))); // SplitLoading 페이지로 이동
      } else {
        fetchSecondCallMembersAndUpdateReadyStatus();
        await Future.delayed(Duration(seconds: 30));
      }
    }
  }
  @override
  void dispose() {
    _isPollingActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 50.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("정산 진행 상황", style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: TEXT_COLOR)),
                Text("정산이 아직 진행 중이에요", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
                Lottie.asset("assets/lotties/orangewalking.json", width: 200.w),
                ...doingMember.map((member) => SplitMembers(member: member)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
