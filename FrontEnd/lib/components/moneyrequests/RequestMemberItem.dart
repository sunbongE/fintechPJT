import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../const/colors/Colors.dart';
import '../../entities/RequestMember.dart';

class RequestMemberItem extends StatefulWidget {
  final RequestMember member;
  final bool isSettledState;
  final Function(bool) onSettledChanged;
  final Function(int) callbackAmount;

  const RequestMemberItem({
    Key? key,
    required this.member,
    required this.isSettledState,
    required this.onSettledChanged, required this.callbackAmount,
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
    amount = widget.member.amount;//생성자 바꾸면 여기도 바꿔야함
  }

  void toggleSettled(bool value) {
    widget.onSettledChanged(value);
    setState(() {
      isSettledState = value;
      if(!value){
        amount = 0;
        //나중에는 islock가져와서 잠금 해제
      }else{
        amount = 1;
      }
      widget.callbackAmount (amount);
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
