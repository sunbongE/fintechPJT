import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

class KeyBoardKey extends StatefulWidget {
  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;

  const KeyBoardKey({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  State<KeyBoardKey> createState() => _KeyBoardKeyState();
}

class _KeyBoardKeyState extends State<KeyBoardKey> {
  Color textColor = Colors.black;

  void temporaryChangeColor() {
    setState(() {
      textColor = PRIMARY_COLOR;
    });

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          textColor = Colors.black;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (widget.label is Icon) {
      content = widget.label;
    } else if (widget.label == null) {
      content = SizedBox();
    } else {
      content = Padding(
        padding: EdgeInsets.symmetric(vertical: 18.h),
        child: Text(
          widget.label,
          style: TextStyle(fontSize: 40.sp, color: textColor),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      width: 90.w,
      height: 90.h,
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: widget.label == null
              ? null
              : () {
                  widget.onTap(widget.value);
                  temporaryChangeColor();
                },
          child: Center(child: content),
        ),
      ),
    );
  }
}