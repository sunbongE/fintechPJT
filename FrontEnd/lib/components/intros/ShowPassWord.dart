import 'package:flutter/material.dart';
import 'package:front/const/colors/Colors.dart';

Widget showPassWord(String password) {
  List<Widget> pwIcons = List.generate(6, (index) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: password.isNotEmpty && password.length > index
              ? BUTTON_COLOR
              : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.square,
          color: password.isNotEmpty && password.length > index
              ? BUTTON_COLOR
              : Colors.grey,
          size: 30.0,
        ),
      ),
    );
  });

  return Container(
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: pwIcons,
      ),
    ),
  );
}
