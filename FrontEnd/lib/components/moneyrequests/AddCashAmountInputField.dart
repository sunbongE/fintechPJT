import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:front/const/colors/Colors.dart';

import 'NumberFormatInputFormatter.dart';

class AddCashAmountInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final String labelText;
  final String hintText;

  const AddCashAmountInputField({
    Key? key,
    required this.controller,
    required this.onSubmitted, required this.labelText, required this.hintText,
  }) : super(key: key);

  @override
  _AddCashAmountInputFieldState createState() => _AddCashAmountInputFieldState();
}

class _AddCashAmountInputFieldState extends State<AddCashAmountInputField> {
  @override
  void initState(){
    if (widget.controller.text.isNotEmpty) {
      final formattedValue = formatInitialValue(widget.controller.text);
      widget.controller.text = formattedValue;
    }
  }
  @override
  void didUpdateWidget(covariant AddCashAmountInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      setState(() {
        final formattedValue = formatInitialValue(widget.controller.text);
        widget.controller.text = formattedValue;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        NumberFormatInputFormatter(),
      ],
      decoration: InputDecoration(
        suffixText: '원',
        border: OutlineInputBorder(),
        label: Text(widget.labelText),
        hintText: widget.hintText,
      ),
      style: TextStyle(
        color: TEXT_COLOR,
        fontSize: 18.sp,
      ),
      onSubmitted: widget.onSubmitted,

    );
  }
}
String formatInitialValue(String initialValue) {
  if (initialValue.isEmpty) return '';
  final formatter = NumberFormat('#,###');
  return formatter.format(int.tryParse(initialValue.replaceAll(',', '')) ?? 0);
}