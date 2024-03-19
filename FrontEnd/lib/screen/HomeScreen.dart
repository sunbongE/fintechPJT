import 'package:flutter/material.dart';
import 'package:front/screen/GroupMain.dart';
import 'package:front/screen/MainPage.dart';
import 'package:front/screen/MyPage.dart';
import 'package:front/screen/MySpended.dart';

import '../providers/store.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  const HomeScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  List<Widget> _pages = [
    MainPage(),
    GroupMain(),
    MySpended(),
    MyPage(),
  ];

  void onTapNavItem(int idx) {
    setState(() {
      _index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: _pages[_index],
        bottomNavigationBar: Theme(
          data: ThemeData(
            // 애니메이션 효과 없애는 부분
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '나의 여행'),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: '그룹'),
              BottomNavigationBarItem(icon: Icon(Icons.poll), label: '내 소비내역'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '마이페이지'),
            ],
            selectedIconTheme: IconThemeData(color: Color(0xffFF9E44)),
            selectedItemColor: Color(0xffFF9E44),
            currentIndex: _index,
            onTap: onTapNavItem,
            type: BottomNavigationBarType.fixed, // 선택 안된 메뉴들도 보이게
          ),
        ),
      ),
    );
  }
}
