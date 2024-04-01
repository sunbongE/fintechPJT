import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../const/colors/Colors.dart';
import '../../entities/RequestMember.dart';
import '../../models/FlutterToastMsg.dart';
import 'AmountInputField.dart';

class RequestModifyItem extends StatefulWidget {
  final RequestMember member;
  final int amount;
  final bool isLocked;
  final Function(bool) onLockedChanged;
  final Function(int) onAmountChanged;
  final int totalAmount;

  const RequestModifyItem({
    Key? key,
    required this.member,
    required this.isLocked,
    required this.onLockedChanged,
    required this.onAmountChanged,
    required this.amount, required this.totalAmount,
  }) : super(key: key);

  @override
  _RequestModifyItemState createState() => _RequestModifyItemState();
}

class _RequestModifyItemState extends State<RequestModifyItem> {
  late TextEditingController amountController;
  late bool isLocked;

  @override
  void initState() {
    super.initState();
    isLocked = widget.isLocked;
    amountController = TextEditingController(
      text: widget.amount.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant RequestModifyItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount) {
      //amountController.text = widget.amount.toString();
      amountController = TextEditingController(
        text: widget.amount.toString(),
      );
      //나중에 isLock관리
    }
  }

  void toggleSettled() {
    widget.onLockedChanged(!isLocked);
    setState(() {
      isLocked = !isLocked;
    });
  }

  // @override
  // void didUpdateWidget(covariant RequestModifyItem oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.isSettledState != widget.isSettledState) {
  //     setState(() {
  //       isSettledState = widget.isSettledState;
  //     });
  //   }
  // }
  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
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
      subtitle: AmountInputField(
        controller: amountController,
        onSubmitted: (value) {
          amountController.text = value.isEmpty ? '0' : amountController.text;
          String removeCommaValue =
              (value.isEmpty ? '0' : value).replaceAll(',', '');
          if(int.parse(removeCommaValue) > widget.totalAmount) {
            removeCommaValue = widget.amount.toString();
            amountController.text = widget.amount.toString();
            FlutterToastMsg('${widget.totalAmount}원 보다 작거나 같은 값을 입력해주세요.');
          }
          widget.onAmountChanged(int.parse(removeCommaValue));
          //isLocked = removeCommaValue == '0' ? false : true;
          print(isLocked);
        },
        onChanged:  (value) {
          if (!isLocked) {
            setState(() {
              isLocked = true;
            });
            widget.onLockedChanged(true);
          }
        },
      ),
      trailing: IconButton(
        icon: Icon(isLocked ? Icons.lock : Icons.lock_open),
        onPressed: () {
          toggleSettled();
        },
      ),
    );
  }
}
