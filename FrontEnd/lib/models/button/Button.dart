import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

class Button extends StatefulWidget {
  final String btnText;
  final VoidCallback? onPressed;

  const Button({
    required this.btnText,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: BUTTON_COLOR,
        minimumSize: Size(
          280.w,
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
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
