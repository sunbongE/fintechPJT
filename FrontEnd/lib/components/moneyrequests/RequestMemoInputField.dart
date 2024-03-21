import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestMemoInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  const RequestMemoInputField({
    Key? key,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  _RequestMemoInputFieldState createState() => _RequestMemoInputFieldState();
}

class _RequestMemoInputFieldState extends State<RequestMemoInputField> {
  @override
  void initState(){
    if (widget.controller.text.isNotEmpty) {
      widget.controller.text = widget.controller.text;
    }
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: "메모를 입력해주세요",
      ),
      style: TextStyle(
        fontSize: 18.sp,
      ),
      onSubmitted: widget.onSubmitted,
    );
  }
}