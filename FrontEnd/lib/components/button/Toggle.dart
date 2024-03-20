import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../const/colors/Colors.dart';

class Toggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onToggle;

  const Toggle({
    Key? key,
    required this.initialValue,
    required this.onToggle,
  }) : super(key: key);

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  late bool isSettled;

  @override
  void initState() {
    super.initState();
    isSettled = widget.initialValue;
  }

  double _calculateScale(double targetWidth, double defaultWidth) {
    return targetWidth / defaultWidth;
  }

  @override
  Widget build(BuildContext context) {
    double defaultSwitchWidth = 59.0.w;
    double targetSwitchWidth = 52.0.w;

    return Transform.scale(
      scale: _calculateScale(targetSwitchWidth, defaultSwitchWidth),
      child: Switch(
        activeColor: BUTTON_COLOR,
        inactiveTrackColor: Colors.black54,
        inactiveThumbColor: Colors.white,
        value: isSettled,
        onChanged: (value) {
          setState(() {
            isSettled = value;
            widget.onToggle(value);
          });
        },
      ),
    );
  }
}
