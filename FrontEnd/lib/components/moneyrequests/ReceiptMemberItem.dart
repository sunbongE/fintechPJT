import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/entities/RequestReceiptDetail.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../../const/colors/Colors.dart';
import '../../entities/RequestMember.dart';
import '../../entities/RequestReceiptDetailMember.dart';
import '../../providers/store.dart';

class ReceiptMemberItem extends StatefulWidget {
  final int groupId;
  final int paymentId;
  final int receiptDetailId;
  final RequestReceiptDetailMember requestReceiptDetailMember;
  final bool PersonalSettle;
  final Function(bool) settleCallback;
  final int amount;
  final Function(int) amountCallback;
  final bool isSplit;

  const ReceiptMemberItem({
    Key? key,
    required this.groupId,
    required this.paymentId,
    required this.receiptDetailId,
    required this.requestReceiptDetailMember,
    required this.settleCallback,
    required this.PersonalSettle,
    required this.amount,
    required this.amountCallback,
    this.isSplit = false,
  }) : super(key: key);

  @override
  _ReceiptMemberItemState createState() => _ReceiptMemberItemState();
}

class _ReceiptMemberItemState extends State<ReceiptMemberItem> {
  late bool isSettled;
  late int amount = 0;
  final UserManager _userManager = UserManager();
  String? userInfo;

  Future<void> _loadUserInfo() async {
    await _userManager.loadUserInfo();
    String token = _userManager.jwtToken !;
    String formattedToken = token.startsWith('Bearer ') ? token.substring(7) : token;
    Map<String, dynamic> payload = Jwt.parseJwt(formattedToken);
    String? kakaoId = payload['kakaoId'];
    setState(() {
      userInfo = kakaoId;
      print(kakaoId);
    });
  }
  @override
  void initState() {
    super.initState();
    isSettled = widget.requestReceiptDetailMember.amountDue > 0 ? true : false;
    amount = widget.requestReceiptDetailMember.amountDue;
    _loadUserInfo();
  }

  void toggleSettled(bool value) {
    widget.settleCallback(value);
    setState(() {
      isSettled = value;
      amount = value ? 1 : 0;
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
      trailing: !widget.isSplit || userInfo == widget.requestReceiptDetailMember.memberId ?Switch(
        value: isSettled,
        activeColor: BUTTON_COLOR,
        inactiveTrackColor: Colors.black54,
        inactiveThumbColor: Colors.white,
        onChanged: (bool value) {
          toggleSettled(value);
        },
      ): SizedBox(),
    );
  }
}
