import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors/Colors.dart';

class ProfileChangeBtn extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const ProfileChangeBtn({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  State<ProfileChangeBtn> createState() => _ProfileChangeBtnState();
}

class _ProfileChangeBtnState extends State<ProfileChangeBtn> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: BOX_COLOR,
        minimumSize: Size(363.w, 35.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        widget.buttonText,
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black,
        ),
      ),
    );
  }
}
