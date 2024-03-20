import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ReseiptIcon extends StatefulWidget {
  final bool isReceipt;
  const ReseiptIcon({Key? key, required this.isReceipt}) : super(key: key);

  @override
  _ReseiptIconState createState() => _ReseiptIconState();
}

class _ReseiptIconState extends State<ReseiptIcon> {
  @override
  Widget build(BuildContext context) {
    var circleColor = Colors.grey;
    if (widget.isReceipt) circleColor = Colors.green;

    return Container(
      width: 44.0.w,
      height: 44.0.h,
      decoration: BoxDecoration(
        color: circleColor, // 원의 색상
        shape: BoxShape.circle, // 원 모양 설정
      ),
      child: Icon(
        Icons.receipt_long_sharp, // 아이콘
        color: Colors.white, // 아이콘 색상
      ),
    );
  }
}