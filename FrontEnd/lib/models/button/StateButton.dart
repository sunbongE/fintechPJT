import 'package:flutter/material.dart';
import 'package:front/const/colors/Colors.dart';

//여행중일때
class TravelingButton extends StatefulWidget {
  final String btnText;

  final VoidCallback? onPressed;

  const TravelingButton({
    required this.btnText,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<TravelingButton> createState() => _ButtonState();
}

class _ButtonState extends State<TravelingButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: COMPLETE_BUTTON_COLOR,
        minimumSize: Size(
          100,
          30,
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
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

    );
  }
}
