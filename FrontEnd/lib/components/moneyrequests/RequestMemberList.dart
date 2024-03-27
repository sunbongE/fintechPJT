import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/entities/RequestCash.dart';
import 'package:front/screen/MoneyRequests/AddCashRequest.dart';
import '../../entities/RequestDetail.dart';
import '../../models/button/SizedButton.dart';
import 'RequestMemberItem.dart';

class RequestMemberList extends StatefulWidget {
  final dynamic requestDetail;
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
  List<bool> isSettledStates = [];
  bool allSettled = false;
  int settledMembersCount = 0;
  late List<int> amountList;
  late List<bool> isLockList;

  @override
  void initState() {
    super.initState();
    if (widget.requestDetail is RequestDetail) {
      RequestDetail tmp = widget.requestDetail;
      isSettledStates =
          tmp.members.map((m) => m.amount != 0).toList();
      settledMembersCount =
          tmp.members
              .where((m) => m.amount != 0)
              .length;
      isLockList = tmp.members.map((m) => m.lock).toList();
      amountList = widget
          .amountList;
    }
    else if(widget.requestDetail is RequestCash) {
      isSettledStates =
      List<bool>.filled(widget.requestDetail.members.length, false);
      settledMembersCount = 0;
      isLockList = List<bool>.filled(widget.requestDetail.members.length, false);
      amountList = widget
          .amountList;
    }
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
      if(value == true){
      if(widget.requestDetail is RequestDetail)
        widget.callbackAmountList(List<int>.filled(amountList.length, (widget.requestDetail.totalPrice/amountList.length).toInt()));
      else if(widget.requestDetail is RequestCash)
        widget.callbackAmountList(List<int>.filled(amountList.length, (widget.requestDetail.transactionBalance/amountList.length).toInt()));
      }
      else
        widget.callbackAmountList(List<int>.filled(amountList.length, 0));

      //전체해제할때 전부 lock풀기
      updateAllSettled();
      print('111111111111111111111111111111111111111111111');
      if(widget.requestDetail is RequestCash) {
        print(widget.requestDetail.transactionBalance);
      }
      // 이게 잘 들어오는지 확인....해야할거같은데
    });
  }
  void didUpdateWidget(covariant RequestMemberList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amountList != widget.amountList) {
      setState(() {
        amountList = widget.amountList;
      });
    }
    if(oldWidget.requestDetail != widget.requestDetail){
      print(widget.requestDetail.toString());
      setState(() {

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
          child: isSettledStates.isNotEmpty
              ? ListView.builder(
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
                  widget.callbackAmountList(amountList);
                  setState(() {});
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
          )
              : Center(
            child: Text('멤버가 없습니다.'),
          ),
        ),
      ],
    );
  }
}
