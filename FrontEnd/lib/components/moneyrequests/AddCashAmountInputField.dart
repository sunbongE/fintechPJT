import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors/Colors.dart';

class AddCashAmountInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;

  const AddCashAmountInputField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  _AddCashAmountInputFieldState createState() => _AddCashAmountInputFieldState();
}

class _AddCashAmountInputFieldState extends State<AddCashAmountInputField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateFocus);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateFocus);
    super.dispose();
  }

  void _updateFocus() {
    if (_isFocused != widget.controller.text.isNotEmpty) {
      setState(() {
        _isFocused = widget.controller.text.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        Container(
          height: 70.h,
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: _isFocused ? '' : widget.hint,
              suffixText: '원',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: GREY_COLOR)
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: GREY_COLOR),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: RANGE_COLOR),
              ),
            ),
            keyboardType: widget.keyboardType,
            focusNode: FocusNode()..addListener(_updateFocus),
          ),
        ),
      ],
    );
  }
}