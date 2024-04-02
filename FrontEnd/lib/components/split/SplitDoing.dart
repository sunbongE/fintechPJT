import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/split/SplitMembers.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/FlutterToastMsg.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:lottie/lottie.dart';

import '../../entities/SplitDoingResponse.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../models/button/SizedButton.dart';
import '../../providers/store.dart';
import '../../repository/api/ApiGroup.dart';
import '../../repository/api/ApiSplit.dart';
import '../../screen/SplitMain.dart';
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
  final UserManager _userManager = UserManager();
  String? userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
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
    bool isCurrentUserInSecondCall =
        secondCallMembers.any((m) => m['kakaoId'] == userInfo);
    setState(() {
      for (var member in doingMember) {
        if (secondCallMembers.any((m) => m['kakaoId'] == member.kakaoId)) {
          member.isReady = true;
        } else {
          member.isReady = false;
        }
      }
      if (!isCurrentUserInSecondCall) {
        _isPollingActive = false;
        FlutterToastMsg("계좌의 잔액을 확인해주세요.");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SplitMain(groupId: widget.groupId)));
      }
    });
  }

  void checkGroupStatusAndNavigate() async {
    while (_isPollingActive) {
      print('폴링중~~~~');
      final res = await getPersonalGroupStatus(widget.groupId);
      print(res);
      if (res.toString() == 'DONE') {
        _isPollingActive = false;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SplitLoading(groupId: widget.groupId)));
      } else {
        fetchSecondCallMembersAndUpdateReadyStatus();
        await Future.delayed(Duration(seconds: 30));
      }
    }
  }

  Future<void> _loadUserInfo() async {
    await _userManager.loadUserInfo();
    String token = _userManager.jwtToken!;
    String formattedToken =
        token.startsWith('Bearer ') ? token.substring(7) : token;
    Map<String, dynamic> payload = Jwt.parseJwt(formattedToken);
    String? kakaoId = payload['kakaoId'];
    setState(() {
      userInfo = kakaoId;
      print(kakaoId);
    });
  }

  @override
  void dispose() {
    _isPollingActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 50.h),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("정산 진행 상황",
                            style: TextStyle(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold,
                                color: TEXT_COLOR)),
                        Text("정산이 아직 진행 중이에요",
                            style: TextStyle(
                                fontSize: 24.sp, fontWeight: FontWeight.bold)),
                        Lottie.asset("assets/lotties/orangewalking.json",
                            width: 200.w),
                        ...doingMember
                            .map((member) => SplitMembers(member: member))
                            .toList(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: SizedButton(
                    btnText: "그룹 목록으로 돌아가기",
                    size: ButtonSize.l,
                    onPressed: () =>
                        buttonSlideAnimationPushAndRemoveUntil(context, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
