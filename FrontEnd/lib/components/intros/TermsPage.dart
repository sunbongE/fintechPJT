import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/intros/ServiceIntro.dart';
import 'package:front/models/button/Button.dart';
import 'package:lottie/lottie.dart';

import '../../models/button/ButtonSlideAnimation.dart';

class TermsPage extends StatefulWidget {
  TermsPage({Key? key}) : super(key: key);

  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  PageController _pageController = PageController();
  List<String> termsFiles = [
    'assets/files/terms1.txt',
    'assets/files/terms2.txt'
  ];
  List<String> termsTitles = ['계좌통합관리서비스 이용약관', '자동이체(납부) 약관'];
  int _currentPageIndex = 0;

  Future<String> loadTerms(String filePath) async {
    return await rootBundle.loadString(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 50.h, 0, 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  termsTitles[_currentPageIndex],
                  style:
                      TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: termsFiles.length,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    },
                    // txt파일을 불러오는 내용
                    itemBuilder: (context, index) {
                      return FutureBuilder<String>(
                        future: loadTerms(termsFiles[index]),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return SingleChildScrollView(
                              padding: EdgeInsets.all(16.0),
                              child: Text(snapshot.data ?? "약관을 불러올 수 없습니다.",
                                  style: TextStyle(fontSize: 16.0)),
                            );
                          } else {
                            return Center(child: Lottie.asset('assets/lotties/orangewalking.json'));
                          }
                        },
                      );
                    },
                  ),
                ),
                Button(
                  btnText: "동의",
                  onPressed: () {
                    if (_pageController.page?.toInt() ==
                        termsFiles.length - 1) {
                      buttonSlideAnimation(
                        context,
                        ServiceIntro(selectedIndex: 3),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
