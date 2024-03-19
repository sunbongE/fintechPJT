import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:intl/intl.dart';

class MyMoney extends StatefulWidget {
  final String MyAccount;

  const MyMoney({Key? key, required this.MyAccount}) : super(key: key);

  @override
  State<MyMoney> createState() => _MyMoneyState();
}

class _MyMoneyState extends State<MyMoney> {
  int myMoneyAmount = 32733;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (widget.MyAccount != null) {
                Clipboard.setData(ClipboardData(text: widget.MyAccount));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('클립보드에 복사되었습니다')),
                );
              }
            },
            child: Text(
              '${widget.MyAccount}',
              style: TextStyle(
                fontSize: 13.sp,
                color: Color(0xff6E6E6E),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Text(
            '${NumberFormat('#,###').format(myMoneyAmount)}원',
            style: TextStyle(
              color: TEXT_COLOR,
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
