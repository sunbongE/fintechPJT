import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/entities/Notification.dart';
import 'package:lottie/lottie.dart';
import '../../repository/api/ApiFcm.dart';

class AlertList extends StatefulWidget {
  const AlertList({Key? key}) : super(key: key);

  @override
  State<AlertList> createState() => _AlertListState();
}

class _AlertListState extends State<AlertList> {
  List<Notificate> notifications = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  void fetchGroups() async {
    setState(() {
      isLoading = true;
    });
    final notificationsJson = await sendNotiPersonal();
    if (notificationsJson != null && notificationsJson.data is List) {
      setState(() {
        notifications = (notificationsJson.data as List)
            .map((item) => Notificate.fromJson(item))
            .toList() // 데이터 파싱
            .reversed // 리스트를 역순으로 뒤집습니다.
            .toList(); // 역순으로 된 리스트를 다시 리스트로 변환합니다.
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("알람 데이터를 불러오는 데 실패했습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('알림 리스트'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lotties/orangewalking.json'),
                  SizedBox(height: 20.h),
                  Text("알림을 불러오고 있습니다"),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                Icon icon;
                switch (notification.type) {
                  case 'INVITE':
                    icon = Icon(Icons.people);
                    break;
                  case 'URGE':
                    icon = Icon(Icons.priority_high);
                    break;
                  case 'SPLIT_MODIFY':
                    icon = Icon(Icons.edit);
                    break;
                  case 'TRANSFER':
                    icon = Icon(Icons.done_all);
                    break;
                  case 'NO_MONEY':
                    icon = Icon(Icons.credit_card_off);
                    break;
                  default:
                    icon = Icon(Icons.done);
                }
                return ListTile(
                  leading: icon,
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      Text(notification.content),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
