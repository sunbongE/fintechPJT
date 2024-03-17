import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/button/Toggle.dart';
import 'package:front/models/Expense.dart';

class MoneyRequestItem extends StatefulWidget {
  final Expense expense;

  MoneyRequestItem({Key? key, required this.expense}) : super(key: key);

  @override
  _MoneyRequestItemState createState() => _MoneyRequestItemState();
}

class _MoneyRequestItemState extends State<MoneyRequestItem> {
  bool isSettled = false;

  @override
  Widget build(BuildContext context) {
    var iconColor = Colors.grey;
    if (widget.expense.isReceipt)
      iconColor = Colors.green;
    isSettled = widget.expense.isSettled;
    print(isSettled);

    return Container(
      width: 368.w,
      height: 80.h,
      child: Card(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.attach_money,
              size: 44,
              color: iconColor,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.expense.place,
                      style: TextStyle(
                        fontSize: 14.sp,
                      )),
                  SizedBox(height: 4.h),
                  Text('날짜: ${widget.expense.date}',
                      style: TextStyle(
                        fontSize: 12.sp,
                      )),
                ],
              ),
            ),

            Text('${widget.expense.amount}원',
                style: TextStyle(
                  fontSize: 18.sp,
                )),
            SizedBox(width: 4.w),
            Toggle(
              initialValue: isSettled,
              onToggle: (value) {
                setState(() {
                  isSettled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
