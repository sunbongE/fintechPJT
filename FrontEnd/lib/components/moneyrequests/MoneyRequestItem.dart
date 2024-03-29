import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/ReceiptIcon.dart';
import 'package:front/models/button/Toggle.dart';
import 'package:front/entities/Expense.dart';
import 'package:intl/intl.dart';

import '../../const/colors/Colors.dart';
import '../../repository/api/ApiMoneyRequest.dart';
import '../../screen/MoneyRequests/MoneyRequestDetail.dart';

class MoneyRequestItem extends StatefulWidget {
  final Expense expense;
  final bool isToggle;
  final bool clickable;
  final int groupId;

  MoneyRequestItem({Key? key, required this.expense, this.isToggle = true, required this.groupId, required this.clickable})
      : super(key: key);

  @override
  _MoneyRequestItemState createState() => _MoneyRequestItemState();
}

class _MoneyRequestItemState extends State<MoneyRequestItem> {
  late bool isSettled;

  @override
  void initState() {
    super.initState();
    isSettled = widget.expense.isSettled;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.clickable
          ? () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MoneyRequestDetail(
                  expense: widget.expense,
                  onSuccess: (bool newState) {
                    setState(() {
                      isSettled = newState;
                    });
                  },
                  groupId: widget.groupId,
                )));
      }
          : null,
      child: Container(
        width: 380.w,
        height: 80.h,
        child: Card(
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReseiptIcon(
                isReceipt: widget.expense.receiptEnrolled,
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 130.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.expense.transactionSummary,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(formatDateString(widget.expense.transactionDate),
                            style: TextStyle(
                              fontSize: 12.sp,
                            )),
                        Text(' '),
                        Text(formatTimeString(widget.expense.transactionTime),
                            style: TextStyle(
                              fontSize: 12.sp,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 110.w,
                child: Text(
                    '${NumberFormat('#,###').format(widget.expense.transactionBalance)}원',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18.sp,
                    )),
              ),
              SizedBox(width: 4.w),
              if (widget.isToggle)
                Switch(
                  value: isSettled,
                  activeColor: BUTTON_COLOR,
                  inactiveTrackColor: Colors.black54,
                  inactiveThumbColor: Colors.white,
                  onChanged: (bool value) {
                    setState(() {
                      isSettled = value;
                      putPaymentsInclude(widget.groupId,widget.expense.transactionId);
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatDateString(String dateString) {
  String year = dateString.substring(0, 4);
  String month = dateString.substring(4, 6);
  String day = dateString.substring(6, 8);
  return "$year-$month-$day";
}

String formatTimeString(String timeString) {
  String hour = timeString.substring(0, 2);
  String minute = timeString.substring(2, 4);
  String second = timeString.substring(4, 6);
  return "$hour:$minute:$second";
}
