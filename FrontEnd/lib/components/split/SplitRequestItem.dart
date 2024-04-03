import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/ReceiptIcon.dart';
import 'package:front/models/button/Toggle.dart';
import 'package:front/entities/Expense.dart';
import 'package:intl/intl.dart';
import '../../screen/MoneyRequests/MoneyRequestDetail.dart';
import 'SplitRequestDetail.dart';

class SplitRequestItem extends StatefulWidget {
  final Expense expense;
  final int groupId;

  SplitRequestItem({Key? key, required this.expense,required this.groupId})
      : super(key: key);

  @override
  _SplitRequestItemState createState() => _SplitRequestItemState();
}

class _SplitRequestItemState extends State<SplitRequestItem> {
  late bool isSettled;

  @override
  void initState() {
    super.initState();
    isSettled = widget.expense.isSettled;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SplitRequestDetail(
                  expense: widget.expense,
                  onSuccess: (bool newState) {
                    setState(() {
                      isSettled = newState;
                    });
                  },
                  groupId: widget.groupId,
                )));
      },
      child: Container(
        width: 380.w,
        height: 80.h,
        child: Card(
          elevation: 0,
          color: Colors.white,
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
