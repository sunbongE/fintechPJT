import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTripHistoryDetail extends StatefulWidget {
  const MyTripHistoryDetail({super.key});

  @override
  State<MyTripHistoryDetail> createState() => _MyTripHistoryDetailState();
}

class _MyTripHistoryDetailState extends State<MyTripHistoryDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 여정 기록',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          children: [
            Text("기록기록"),
            Text("기록기록"),
            Text("기록기록"),
            Text("기록기록"),
          ],
        ),
      ),
    );
  }
}
