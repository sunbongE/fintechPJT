import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap(widget.value);
      },
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Container(
          child: Center(
            child: widget.label is String
                ? Text(
              widget.label,
              style: TextStyle(
                fontSize: 40,
              ),
            )
                : widget.label,
          ),
        ),
      ),
    );
  }
}
