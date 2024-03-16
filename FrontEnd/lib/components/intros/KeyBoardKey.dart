import 'package:flutter/material.dart';
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
      setState(() {
        textColor = Colors.black;
      });
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
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Text(
          widget.label,
          style: TextStyle(fontSize: 40, color: textColor),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        widget.onTap(widget.value);
        temporaryChangeColor();
      },
      child: Container(
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}
