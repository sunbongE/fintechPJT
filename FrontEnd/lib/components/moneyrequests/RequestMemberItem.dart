import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../const/colors/Colors.dart';
import '../../entities/RequestMember.dart';

class RequestMemberItem extends StatefulWidget {
  final RequestMember member;
  final bool isSettledState;
  final Function(bool) onSettledChanged;

  const RequestMemberItem({
    Key? key,
    required this.member,
    required this.isSettledState,
    required this.onSettledChanged,
  }) : super(key: key);

  @override
  _RequestMemberItemState createState() => _RequestMemberItemState();
}

class _RequestMemberItemState extends State<RequestMemberItem> {
  late bool isSettledState;

  @override
  void initState() {
    super.initState();
    isSettledState = widget.isSettledState;
  }

  void toggleSettled(bool value) {
    widget.onSettledChanged(value);
    setState(() {
      isSettledState = value;
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
          width: 60,
          height: 60,
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
        '${NumberFormat('#,###').format(widget.member.amount)}원',
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
