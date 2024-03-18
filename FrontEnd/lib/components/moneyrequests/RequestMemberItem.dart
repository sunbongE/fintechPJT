import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../const/colors/Colors.dart';
import '../../models/RequestMember.dart';
import '../button/Toggle.dart';

// StatefulWidget으로 클래스 선언
class RequestMemberItem extends StatefulWidget {
  final RequestMember member;
  final bool isSettled;
  final ValueChanged<bool> onToggle;

  const RequestMemberItem({
    Key? key,
    required this.member,
    required this.isSettled,
    required this.onToggle,
  }) : super(key: key);

  @override
  _RequestMemberItemState createState() => _RequestMemberItemState();
}

// 상태 관리를 위한 _RequestMemberItemState 클래스
class _RequestMemberItemState extends State<RequestMemberItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          width: 60,//여기에 반응형 적용하면 원이 찌그러짐
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
      trailing: Toggle(
        initialValue: widget.isSettled,
        onToggle: widget.onToggle,
      ),
    );
  }
}