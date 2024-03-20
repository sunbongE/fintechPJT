import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/providers/store.dart';
import 'package:intl/intl.dart';

class MySpendItem extends StatefulWidget {
  final Map<String, dynamic>? spend;

  const MySpendItem({required this.spend, super.key});

  @override
  State<MySpendItem> createState() => _MySpendItemState();
}

class _MySpendItemState extends State<MySpendItem> {
  var userManager = UserManager();

  @override
  Widget build(BuildContext context) {
    userManager.loadUserInfo();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.spend?['store_name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "거래시간",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${widget.spend?['transactionDate']} ${widget.spend?['transactionTime']['hour']}:${widget.spend?['transactionTime']['minute']}:${widget.spend?['transactionTime']['second']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "거래금액",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(widget.spend?['cost'])}원',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: TEXT_COLOR),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "결재자",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${userManager.name}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
