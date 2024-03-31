import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/entities/RequestReceiptDetail.dart';
import 'package:intl/intl.dart';
import '../../const/colors/Colors.dart';
import '../../entities/RequestMember.dart';
import '../../entities/RequestReceiptDetailMember.dart';

class ReceiptMemberItem extends StatefulWidget {
  final int groupId;
  final int paymentId;
  final int receiptDetailId;
  final RequestReceiptDetailMember requestReceiptDetailMember;
  final bool PersonalSettle;
  final Function(bool) settleCallback;
  final int amount;
  final Function(int) amountCallback;

  const ReceiptMemberItem({
    Key? key,
    required this.groupId,
    required this.paymentId,
    required this.receiptDetailId,
    required this.requestReceiptDetailMember, required this.settleCallback, required this.PersonalSettle, required this.amount, required this.amountCallback,
  }) : super(key: key);

  @override
  _ReceiptMemberItemState createState() => _ReceiptMemberItemState();
}

class _ReceiptMemberItemState extends State<ReceiptMemberItem> {
  late bool isSettled;
  late int amount = 0;

  @override
  void initState() {
    super.initState();
    isSettled = widget.requestReceiptDetailMember.amountDue > 0 ? true:false;
    amount = widget.requestReceiptDetailMember.amountDue;
  }

  void toggleSettled(bool value) {
    widget.settleCallback(value);
    setState(() {
      isSettled = value;
      amount = value ? 1 : 0;
      //widget.onLockedChanged(false);
      widget.amountCallback(amount);
      amount = widget.amount;
    });
  }

  @override
  void didUpdateWidget(covariant ReceiptMemberItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.PersonalSettle != widget.PersonalSettle) {
      setState(() {
        isSettled = widget.PersonalSettle;
      });
    }
    if (oldWidget.amount != widget.amount) {
      setState(() {
        amount = widget.amount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          width: 60.w,
          height: 60.h,
          child: Image.network(widget.requestReceiptDetailMember.thumbnailImage,
              fit: BoxFit.cover),
        ),
      ),
      title: Text(
        widget.requestReceiptDetailMember.name,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${NumberFormat('#,###').format(amount)}원',
        style: TextStyle(
          color: TEXT_COLOR,
          fontSize: 18.sp,
        ),
      ),
      trailing: Switch(
        value: isSettled,
        activeColor: BUTTON_COLOR,
        inactiveTrackColor: Colors.black54,
        inactiveThumbColor: Colors.white,
        onChanged: (bool value) {
          toggleSettled(value);
        },
      ),
    );
  }
}
