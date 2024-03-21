import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/screen/GroupMain.dart';
import 'package:front/screen/MainPage.dart';
import 'package:front/screen/MyPage.dart';
import 'package:front/screen/MySpended.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  DateTime? lastPressed;

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

    // 뒤로가기 두 번 누르면 어플 종료
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastPressed == null || now.difference(lastPressed!) > Duration(seconds: 2)) {
          lastPressed = DateTime.now();
          final snackBar = SnackBar(
            content: Text('뒤로 가기 버튼을 한 번 더 누르면 앱이 종료됩니다.'),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        }
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: _pages[_index],
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: '나의 여행'),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: '그룹'),
              BottomNavigationBarItem(icon: Icon(Icons.poll), label: '내 소비내역'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), label: '마이페이지'),
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
