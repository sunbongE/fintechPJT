import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

class isDoneContainer extends StatelessWidget {
  final bool groupState;

  const isDoneContainer({Key? key, required this.groupState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.yellow.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '정산완료',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
