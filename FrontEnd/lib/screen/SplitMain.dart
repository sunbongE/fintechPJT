import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/split/SplitDoing.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:front/providers/store.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../components/split/SplitMainList.dart';
import '../entities/SplitMemberResponse.dart';
import '../models/button/ButtonSlideAnimation.dart';
import 'MoneyRequest.dart';

class SplitMain extends StatefulWidget {
  const SplitMain({super.key});

  @override
  _SplitMainState createState() => _SplitMainState();
}

List<Map<String, dynamic>> rawData = [
  {
    'memberId': 11111,
    'name': 'asdf',
    'receiveAmount': 10000,
    'sendAmount': 2000
  },
  {
    'memberId': 11111,
    'name': 'asdf',
    'receiveAmount': 10000,
    'sendAmount': 2000
  },
  {
    'memberId': 11111,
    'name': 'asdf',
    'receiveAmount': 10000,
    'sendAmount': 2000
  },
  {
    'memberId': 11111,
    'name': 'asdf',
    'receiveAmount': 10000,
    'sendAmount': 2000
  },
  {
    'memberId': 11111,
    'name': 'asdf',
    'receiveAmount': 10000,
    'sendAmount': 2000
  },
  {
    'memberId': 11111,
    'name': 'asdf',
    'receiveAmount': 10000,
    'sendAmount': 2000
  },
  {
    'memberId': 11111,
    'name': 'asdf',
    'receiveAmount': 10000,
    'sendAmount': 2000
  },
  {
    'memberId': 11111,
    'name': 'asdf',
    'receiveAmount': 10000,
    'sendAmount': 2000
  }
];

class _SplitMainState extends State<SplitMain> {
  final UserManager _userManager = UserManager();
  String? userInfo;
  List<SplitMemberResponse> memberList =
      rawData.map((data) => SplitMemberResponse.fromJson(data)).toList();

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

  Future<void> _loadMemberData() async {
    // setState(() {
    //   memberList = rawData.map((data) => YJMemberResponse.fromJson(data)).toList();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 50.h),
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
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              memberList.isEmpty
                  ? Center(
                      child: Lottie.asset('assets/lotties/orangewalking.json'),
                    )
                  : SplitMainList(memberList: memberList,),
              SizedBox(height: 8.h),
              SizedButton(
                btnText: '정산하기',
                size: ButtonSize.l,
                onPressed: () => buttonSlideAnimation(context, SplitDoing()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
