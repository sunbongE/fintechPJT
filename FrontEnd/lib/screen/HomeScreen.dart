import 'package:flutter/material.dart';
import 'package:front/components/Navbar.dart';
import 'package:front/screen/GroupMain.dart';
import 'package:front/screen/MainPage.dart';
import 'package:front/screen/MyPage.dart';
import 'package:front/screen/MySpended.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _index = 0;

  List<Widget> _pages = [
    MainPage(),
    GroupMain(),
    MySpended(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_index],
        bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: IconThemeData(
            color: Color(0xffFF9E44),
          ),
          selectedLabelStyle: TextStyle(
            color: Color(0xffFF9E44),
          ),
          currentIndex: _index,
          onTap: (value) {
            setState(() {
              _index = value;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Color(0xff636E72),
                ),
                label: '나의 여행'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.group,
                  color: Color(0xff636E72),
                ),
                label: '그룹'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.poll,
                  color: Color(0xff636E72),
                ),
                label: '내 소비내역'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_circle,
                  color: Color(0xff636E72),
                ),
                label: '나의 여행'),
          ],
        ),
      ),
    );
  }
}
