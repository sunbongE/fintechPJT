import 'package:flutter/material.dart';
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
  late bool isReceipt;

  @override
  void initState() {
    super.initState();
    isReceipt = widget.initialValue;
  }

  double _calculateScale(double targetWidth, double defaultWidth) {
    // Transform.scale에 적용할 스케일 계산
    return targetWidth / defaultWidth;
  }

  @override
  Widget build(BuildContext context) {
    // 기본 Switch의 대략적인 가로 사이즈 (Flutter 기본값을 기준으로 함)
    double defaultSwitchWidth = 59.0; // 조절 필요
    // 원하는 Switch의 가로 사이즈
    double targetSwitchWidth = 52.0;

    return Transform.scale(
      // 가로 사이즈에 맞춘 스케일 계산
      scale: _calculateScale(targetSwitchWidth, defaultSwitchWidth),
      child: Switch(
        activeColor: BUTTON_COLOR,
        value: isReceipt,
        onChanged: (value) {
          setState(() {
            isReceipt = value;
            widget.onToggle(value); // 부모 위젯에 상태 변경을 알림
          });
        },
      ),
    );
  }
}
