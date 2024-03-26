import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../entities/RequestDetail.dart';
import '../../models/button/SizedButton.dart';
import 'RequestMemberItem.dart';

class RequestMemberList extends StatefulWidget {
  final RequestDetail requestDetail;
  final Function(bool) allSettledCallback;
  final List<int> amountList;
  final Function(List<int>) callbackAmountList;
  final Function(List<bool>) isLockList;

  const RequestMemberList({
    Key? key,
    required this.requestDetail,
    required this.allSettledCallback,
    required this.callbackAmountList,
    required this.amountList,
    required this.isLockList,
  }) : super(key: key);

  @override
  _RequestMemberListState createState() => _RequestMemberListState();
}

class _RequestMemberListState extends State<RequestMemberList> {
  late List<bool> isSettledStates;
  bool allSettled = false;
  int settledMembersCount = 0;
  late List<int> amountList;
  late List<bool> isLockList;

  @override
  void initState() {
    super.initState();
    isSettledStates =
        widget.requestDetail.members.map((m) => m.amount != 0).toList();
    settledMembersCount =
        widget.requestDetail.members.where((m) => m.amount != 0).length;
    isLockList = widget.requestDetail.members.map((m) => m.lock).toList();
    amountList = widget
        .amountList; //widget.requestDetail.members.map((m) => m.amount).toList();
  }

  void updateAllSettled() {
    settledMembersCount = isSettledStates.where((element) => element).length;
    allSettled = isSettledStates.any((element) => element);
    widget.allSettledCallback(allSettled);
  }

  // 전체 선택/해제 기능
  void toggleAll(bool value) {
    setState(() {
      isSettledStates = List<bool>.filled(isSettledStates.length, value);
      print('isSettledStates: $isSettledStates');
      widget.isLockList(List<bool>.filled(isLockList.length, value));
      if(value == true)
      widget.callbackAmountList(List<int>.filled(amountList.length, (widget.requestDetail.totalPrice/amountList.length).toInt()));
      else
        widget.callbackAmountList(List<int>.filled(amountList.length, 0));

      //전체해제할때 전부 lock풀기
      updateAllSettled();
    });
  }
  void didUpdateWidget(covariant RequestMemberList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amountList != widget.amountList) {
      setState(() {
        amountList = widget.amountList;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    //isSettled = widget.requestDetail.isSettled;
    return Column(
      children: [
        SizedBox(
          width: 370.w,
          child: Row(
            children: [
              Text(
                '함께한 멤버',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(' | '),
              Text('$settledMembersCount명'),
              Spacer(),
              SizedButton(
                btnText: allSettled ? '전체 해제' : '전체 선택',
                size: ButtonSize.s,
                borderRadius: 10,
                onPressed: () {
                  toggleAll(!allSettled);
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.builder(
            itemCount: widget.requestDetail.members.length,
            itemBuilder: (context, index) {
              final member = widget.requestDetail.members[index];
              return RequestMemberItem(
                member: member,
                isSettledState: isSettledStates[index],
                onSettledChanged: (bool value) {
                  setState(() {
                    isSettledStates[index] = value;
                    updateAllSettled();
                  });
                },
                callbackAmount: (int value) {
                  amountList[index] = value;
                  widget.callbackAmountList(amountList);setState(() {

                  });
                },
                onLockedChanged: (bool value) {
                  setState(() {
                    isLockList[index] = value;
                    widget.isLockList(isLockList);
                  });
                },
                amount: amountList[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
