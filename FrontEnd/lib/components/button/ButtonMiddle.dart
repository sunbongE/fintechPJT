import 'package:flutter/material.dart';
import 'package:front/const/colors/Colors.dart';

class ButtonMiddle extends StatefulWidget {
  final String btnText;
  final VoidCallback? onPressed;

  const ButtonMiddle({
    required this.btnText,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<ButtonMiddle> createState() => _ButtonState();
}

class _ButtonState extends State<ButtonMiddle> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: BUTTON_COLOR,
        minimumSize: Size(
          147,
          46,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
      ),
      child: Text(widget.btnText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}