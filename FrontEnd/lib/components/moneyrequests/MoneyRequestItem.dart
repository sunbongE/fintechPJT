import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/ReceiptIcon.dart';
import 'package:front/models/button/Toggle.dart';
import 'package:front/entities/Expense.dart';
import 'package:intl/intl.dart';

import '../../const/colors/Colors.dart';
import '../../screen/MoneyRequests/MoneyRequestDetail.dart';

class MoneyRequestItem extends StatefulWidget {
  final Expense expense;
  final bool isToggle;

  MoneyRequestItem({Key? key, required this.expense, this.isToggle = true})
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
      onTap: () {
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
                    )));
      },
      child: Container(
        width: 368.w,
        height: 80.h,
        child: Card(
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReseiptIcon(isReceipt: widget.expense.isReceipt,),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.expense.place,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 4.h),
                    Text('날짜: ${widget.expense.date}',
                        style: TextStyle(
                          fontSize: 12.sp,
                        )),
                  ],
                ),
              ),
              Text('${NumberFormat('#,###').format(widget.expense.amount)}원',
                  style: TextStyle(
                    fontSize: 18.sp,
                  )),
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
