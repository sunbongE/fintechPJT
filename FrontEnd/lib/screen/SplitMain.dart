import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/split/SplitDoing.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:front/providers/store.dart';
import 'package:lottie/lottie.dart';
import '../components/calculate/Jjatury.dart';
import '../components/split/SplitMainList.dart';
import '../entities/SplitMemberResponse.dart';
import '../models/Biometrics.dart';
import '../models/PassWordCertification.dart';
import '../repository/api/ApiSplit.dart';

class SplitMain extends StatefulWidget {
  final int groupId;

  const SplitMain({super.key, required this.groupId});

  @override
  _SplitMainState createState() => _SplitMainState();
}

class _SplitMainState extends State<SplitMain> {
  final UserManager _userManager = UserManager();
  String? userInfo;
  List<SplitMemberResponse> memberList = [];

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
        processPutAndNavigate();
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
                      processPutAndNavigate();
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

  Future<void> processPutAndNavigate() async {
    int remainder = await putSecondCall(widget.groupId);
    if (remainder >= 0) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) =>
              Jjatury(groupId: widget.groupId, remainder: remainder)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SplitDoing(groupId: widget.groupId)));
    }
  }

  Future<void> _loadMemberData() async {
    try {
      final response = await getYeojung(widget.groupId);

      final List<dynamic> responseData = response.data;
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(responseData);
      setState(() {
        memberList =
            data.map((data) => SplitMemberResponse.fromJson(data)).toList();
      });
    } catch (err) {
      // 데이터 로딩 중 에러가 발생한 경우 처리
      print('멤버 데이터 로딩 실패: $err');
    }
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
                              child: Lottie.asset(
                                  'assets/lotties/orangewalking.json'),
                            )
                          : SplitMainList(
                              memberList: memberList, groupId: widget.groupId,
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
      ),
    );
  }
}
