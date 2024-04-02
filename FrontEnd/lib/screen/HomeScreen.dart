import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:front/components/groups/GroupInvitedItem.dart';
import 'package:front/components/split/SplitDone.dart';
import 'package:front/screen/GroupMain.dart';
import 'package:front/screen/MainPage.dart';
import 'package:front/screen/MyPage.dart';
import 'package:front/screen/MySpended.dart';
import 'package:front/screen/SplitMain.dart';
import 'groupscreens/GroupItem.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  int _index = 0;
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse details) async {
      if (details.payload != null) {
        final data = jsonDecode(details.payload!);
        if (details.notificationResponseType == NotificationResponseType.selectedNotification) {
          _navigateToSpecificPageWhenAppIsForeground(data);
        }
      }
    });
    _index = widget.initialIndex;
    _listenToForegroundMessages();
    _checkInitialMessage();
    _listenToNotificationOpenedApp();
  }

  // 백그라운드 상태에서 온 알림메세지 확인
  void _checkInitialMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _navigateToSpecificPage(initialMessage.data);
    }
  }

  // 앱이 백그라운드에서 포그라운드로 전환될 때 처리
  void _listenToNotificationOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToSpecificPage(message.data);
    });
  }

  // 앱이 포그라운드 상태일 때 알림 탭 처리
  void _navigateToSpecificPageWhenAppIsForeground(Map<String, dynamic> data) {
    final type = data['type'];
    if (data['groupId'] is String) {
      final groupId = int.parse(data['groupId']);
      switch (type) {
        case 'INVITE':
          break;
        case 'SPLIT':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SplitMain(groupId: groupId)),
        );
        break;
        case 'TRANSFER':
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SplitDone(groupId: groupId)),
        );
        break;
        case 'NO_MONEY':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SplitMain(groupId: groupId)),
          );
          break;
        case 'SPLIT_MODIFY':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SplitMain(groupId: groupId)),
          );
          break;
        case 'URGE':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GroupInvitedItem(groupId: groupId)),
          );
          break;
      }
    }
  }

  // 확인하고 바로 navigate
  void _navigateToSpecificPage(Map<String, dynamic> data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final type = data['type'];
      if (data['groupId'] is String) {
        final groupId = int.parse(data['groupId']);
        switch (type) {
          case 'INVITE':
            break;
          case 'SPLIT':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SplitMain(groupId: groupId)),
            );
            break;
          case 'TRANSFER':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SplitDone(groupId: groupId)),
            );
            break;
          case 'NO_MONEY':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SplitMain(groupId: groupId)),
            );
            break;
          case 'SPLIT_MODIFY':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SplitMain(groupId: groupId)),
            );
            break;
          case 'URGE':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GroupInvitedItem(groupId: groupId)),
            );
            break;
        }
      }
    });
  }

  // 포그라운드 상태에서 온 알림메세지
  void _listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("포그라운드에서 메시지 수신: 데이터: ${message.data}");
      _showNotificationWithDefaultSound(message);
    });
  }

  // 알림창 보여줌
  Future<void> _showNotificationWithDefaultSound(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'high_importance_notification',
      importance: Importance.max,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
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
        exit(0);
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
