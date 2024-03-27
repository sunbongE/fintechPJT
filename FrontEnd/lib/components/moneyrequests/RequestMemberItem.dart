import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../const/colors/Colors.dart';
import '../../entities/RequestMember.dart';

class RequestMemberItem extends StatefulWidget {
  final RequestMember member;
  final bool isSettledState;
  final int amount;
  final Function(bool) onSettledChanged;
  final Function(int) callbackAmount;
  final Function(bool) onLockedChanged;

  const RequestMemberItem({
    Key? key,
    required this.member,
    required this.isSettledState,
    required this.onSettledChanged,
    required this.callbackAmount,
    required this.onLockedChanged,
    required this.amount,
  }) : super(key: key);

  @override
  _RequestMemberItemState createState() => _RequestMemberItemState();
}

class _RequestMemberItemState extends State<RequestMemberItem> {
  late bool isSettledState;
  late int amount = 0;

  @override
  void initState() {
    super.initState();
    isSettledState = widget.isSettledState;
    amount = widget.amount;
  }

  void toggleSettled(bool value) {
    widget.onSettledChanged(value);
    setState(() {
      isSettledState = value;
      amount = value ? 1 : 0;
      widget.onLockedChanged(false);
      widget.callbackAmount(amount);
      amount = widget.amount;
    });
  }

  @override
  void didUpdateWidget(covariant RequestMemberItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSettledState != widget.isSettledState) {
      setState(() {
        isSettledState = widget.isSettledState;
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
          child: Image.network(widget.member.profileUrl, fit: BoxFit.cover),
        ),
      ),
      title: Text(
        widget.member.name,
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
        value: isSettledState,
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
