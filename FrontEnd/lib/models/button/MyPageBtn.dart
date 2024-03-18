import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

class MyPageBtn extends StatefulWidget {
  final String btnText;
  final VoidCallback? onPressed;

  const MyPageBtn({
    required this.btnText,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<MyPageBtn> createState() => _MyPageBtnState();
}

class _MyPageBtnState extends State<MyPageBtn> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: 50.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: MY_PAGE_BTN.withOpacity(0.4),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                widget.btnText,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
