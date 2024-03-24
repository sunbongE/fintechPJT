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
  final Function(List<int>) callbackAmountList;

  const RequestMemberList({
    Key? key,
    required this.requestDetail,
    required this.allSettledCallback, required this.callbackAmountList,
  }) : super(key: key);

  @override
  _RequestMemberListState createState() => _RequestMemberListState();
}

class _RequestMemberListState extends State<RequestMemberList> {
  late List<bool> isSettledStates;
  bool allSettled = false;
  int settledMembersCount = 0;
  late List<int> amountList;

  @override
  void initState() {
    super.initState();
    isSettledStates =
        widget.requestDetail.members.map((m) => m.amount!=0).toList();
    settledMembersCount =
        widget.requestDetail.members.where((m) => m.amount!=0).length;
    amountList = widget.requestDetail.members.map((m) => m.amount).toList();
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
      updateAllSettled();
    });
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
                btnText: '전체선택',
                size: ButtonSize.s,
                borderRadius: 10,
                onPressed: () {
                  toggleAll(true);
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
                    //print('isSettledStates: $isSettledStates');
                    updateAllSettled();
                  });
                }, callbackAmount: (int value) { setState((){
                amountList[index]=value;
                print(amountList);
              });},
              );
            },
          ),
        ),
      ],
    );
  }
}
