import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

class GroupAddButton2 extends StatefulWidget {
  final String btnText;
  final VoidCallback? onPressed;

  const GroupAddButton2({
    required this.btnText,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<GroupAddButton2> createState() => _GroupAddButton2State();
}

class _GroupAddButton2State extends State<GroupAddButton2> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: BUTTON_COLOR,
        minimumSize: Size(
          298.w,
          50.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            30,
          ),
        ),
      ),
      child: Text(widget.btnText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
        ),
      ),
    );
  }
}
