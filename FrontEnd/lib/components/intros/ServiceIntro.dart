import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/intros/CreatePwPage.dart';
import 'package:front/components/intros/IntroBox.dart';
import 'package:front/screen/HomeScreen.dart';
import '../../providers/store.dart';
import '../../repository/api/ApiLogin.dart';

class ServiceIntro extends StatefulWidget {
  final int selectedIndex;

  const ServiceIntro({super.key, this.selectedIndex = 0});

  @override
  State<ServiceIntro> createState() => _ServiceIntroState();
}

class _ServiceIntroState extends State<ServiceIntro> {
  final List<Map<String, dynamic>> introInfo = [
    {
      'idx': 0,
      "title": "결제 내역을\n한번에 확인해보세요",
      "desc": "내 카드 연동으로\n결제내역을 한눈에 확인해보세요",
    },
    {
      'idx': 1,
      "title": "번거로운 정산도\n한번에",
      "desc": "각자 필요한 만큼\n손쉬운 정산을 할 수 있어요",
    },
    {
      'idx': 2,
      "title": "은행에서 정보를\n받는 중입니다.",
      "desc": "손쉽게 은행정보를 받아보세요",
    },
    {
      'idx': 3,
      "title": "가입이 완료되었습니다",
      "desc": "함께 정산의 여정 을 떠나볼까요?",
    }
  ];
  final PageController _pageController = PageController();
  final int stopIdex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedIndex != 0) {
        _pageController.jumpToPage(widget.selectedIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/Service Intro_1.png"),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            top: true,
            bottom: false,
            child: PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: introInfo.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.asset(
                      "assets/images/introIcon$index.png",
                      width: 403.05.w,
                      height: 476.49.h,
                    ),
                    IntroBox(
                      title: introInfo[index]['title'],
                      desc: introInfo[index]['desc'],
                      onNext: () async {
                        if (index < stopIdex) {
                          _pageController.animateToPage(
                            index + 1,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else if (index == stopIdex) {
                          Response res = await postMyData();
                          print(res.data['message']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatePwPage(),
                            ),
                          );
                        } else {
                          UserManager().updateLoginState(true);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
