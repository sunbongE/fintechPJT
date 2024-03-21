import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

enum ButtonSize { l, m, s, xs }

class SizedButton extends StatefulWidget {
  final String btnText;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final double borderRadius;
  final enable;

  const SizedButton({
    required this.btnText,
    this.size = ButtonSize.m,
    this.borderRadius = 15.0,
    this.onPressed,
    this.enable = true,
    Key? key,
  }) : super(key: key);

  @override
  State<SizedButton> createState() => _SizedButtonState();
}

class _SizedButtonState extends State<SizedButton> {
  Size _getButtonSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.l:
        return Size(298.w, 66.h);
      case ButtonSize.m:
        return Size(147.w, 46.h);
      case ButtonSize.s:
        return Size(87.w, 41.h);
      case ButtonSize.xs:
        return Size(73.w, 33.h);
      default:
        return Size(298.w, 66.h);
    }
  }
  double _getFontSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.l:
        return 20.sp;
      case ButtonSize.m:
        return 16.sp;
      case ButtonSize.s:
        return 13.sp;
      case ButtonSize.xs:
        return 13.sp;
      default:
        return 16.sp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = _getButtonSize(widget.size);
    final fontSize = _getFontSize(widget.size);
    return ElevatedButton(
      onPressed: widget.enable ? widget.onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: BUTTON_COLOR,
        minimumSize: buttonSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
        ),
      ),
      child: Text(
        widget.btnText,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
