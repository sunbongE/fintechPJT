import 'package:flutter/material.dart';
import 'package:front/components/mains/MainInfo.dart';
import 'package:front/const/colors/Colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: MyInfoMain(),

    );
  }
}
