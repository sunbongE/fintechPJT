import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/split/SplitDoing.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:front/providers/store.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../components/split/SplitMainList.dart';
import '../entities/SplitMemberResponse.dart';
import '../models/Biometrics.dart';
import '../models/PassWordCertification.dart';
import '../models/button/ButtonSlideAnimation.dart';
import 'MoneyRequest.dart';

class SplitMain extends StatefulWidget {
  final int groupId;

  const SplitMain({super.key, required this.groupId});

  @override
  _SplitMainState createState() => _SplitMainState();
}

List<Map<String, dynamic>> rawData = [
  {'memberId': 11111, 'name': 'asdf', 'receiveAmount': 10000, 'sendAmount': 2000},
  {'memberId': 11111, 'name': 'asdf', 'receiveAmount': 10000, 'sendAmount': 2000},
  {'memberId': 11111, 'name': 'asdf', 'receiveAmount': 10000, 'sendAmount': 2000},
  {'memberId': 11111, 'name': 'asdf', 'receiveAmount': 10000, 'sendAmount': 2000},
  {'memberId': 11111, 'name': 'asdf', 'receiveAmount': 10000, 'sendAmount': 2000},
  {'memberId': 11111, 'name': 'asdf', 'receiveAmount': 10000, 'sendAmount': 2000},
  {'memberId': 11111, 'name': 'asdf', 'receiveAmount': 10000, 'sendAmount': 2000},
  {'memberId': 11111, 'name': 'asdf', 'receiveAmount': 10000, 'sendAmount': 2000}
];

class _SplitMainState extends State<SplitMain> {
  final UserManager _userManager = UserManager();
  String? userInfo;
  List<SplitMemberResponse> memberList = rawData.map((data) => SplitMemberResponse.fromJson(data)).toList();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadMemberData();
  }

  Future<void> _loadUserInfo() async {
    await _userManager.loadUserInfo();
    setState(() {
      userInfo = _userManager.name;
    });
  }

  // 생체인증
  Future<bool> _authenticate() async {
    bool? authenticated = await CheckBiometrics();
    return authenticated ?? false;
  }

  // 생체인증 (true || onSuccess 되면 다음페이지)
  void IdentityVerification() async {
    bool authenticated = await _authenticate();
    if (authenticated) {
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SplitDoing(groupId: widget.groupId)));
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PassWordCertification(
                  onSuccess: () {
                    if (mounted) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => SplitDoing(groupId: widget.groupId)));
                    }
                  },
                ),
              ),
            );
          }
        },
      );
    }
  }

  Future<void> _loadMemberData() async {
    // setState(() {
    //   memberList = rawData.map((data) => YJMemberResponse.fromJson(data)).toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 0.h),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: userInfo ?? '',
                              style: TextStyle(
                                fontSize: 50.sp,
                                fontWeight: FontWeight.bold,
                                color: TEXT_COLOR,
                              ),
                            ),
                            TextSpan(
                              text: userInfo != null ? '님의 이번 여정' : '',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    memberList.isEmpty
                        ? Center(
                            child: Lottie.asset('assets/lotties/orangewalking.json'),
                          )
                        : SplitMainList(
                            memberList: memberList,
                          ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
              Positioned(
                bottom: 30.h,
                left: 50.w,
                right: 50.w,
                child: SizedButton(
                  btnText: '정산하기',
                  size: ButtonSize.l,
                  onPressed: () => IdentityVerification(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
