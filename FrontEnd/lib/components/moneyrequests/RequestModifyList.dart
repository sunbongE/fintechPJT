import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../entities/RequestDetail.dart';
import '../../models/button/SizedButton.dart';
import 'RequestMemberItem.dart';
import 'RequestModifyItem.dart';

class RequestModifyList extends StatefulWidget {
  final RequestDetail requestDetail;
  final List<int> requestAmount;
  final Function(List<bool>) isLockedList;
  final Function(List<int>) personalAmounts;

  const RequestModifyList({
    Key? key,
    required this.requestDetail,
    required this.isLockedList,
    required this.personalAmounts, required this.requestAmount,
  }) : super(key: key);

  @override
  _RequestModifyListState createState() => _RequestModifyListState();
}

class _RequestModifyListState extends State<RequestModifyList> {
  late List<bool> isLockes;
  //bool allLocked = false;
  late List<int> personalAmounts;
  int settledMembersCount = 0;

  @override
  void initState() {
    super.initState();
    isLockes = widget.requestDetail.members.map((m) => m.lock).toList();
    settledMembersCount =
        widget.requestDetail.members.where((m) => m.amount!=0).length;
    personalAmounts =
        widget.requestAmount;
  }

  @override
  void didUpdateWidget(covariant RequestModifyList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.requestAmount, widget.requestAmount)) {
      setState(() {
        personalAmounts = widget.requestAmount;
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
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.builder(
            itemCount: widget.requestDetail.members.length,
            itemBuilder: (context, index) {
              final member = widget.requestDetail.members[index];
              return RequestModifyItem(
                member: member,
                isLocked: isLockes[index],
                amount: personalAmounts[index],
                onLockedChanged: (bool value) {
                  setState(() {
                    isLockes[index] = value;
                    widget.isLockedList(isLockes);
                  });
                },
                onAmountChanged: (int value) {
                  setState(() {
                    personalAmounts[index] = value;
                    widget.personalAmounts(personalAmounts);
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
