import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyGroupRequest extends StatelessWidget {
  final String requestDetails;

  const MyGroupRequest({Key? key, required this.requestDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '내가 요청한 정산 내역',
          style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0.h),
        Center(
          child: Text(requestDetails),
        ),
      ],
    );
  }
}
