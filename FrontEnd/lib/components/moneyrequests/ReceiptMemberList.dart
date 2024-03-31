import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/MoneyRequestDetailBottom.dart';
import 'package:front/entities/RequestReceiptDetail.dart';
import 'package:front/entities/RequestReceiptDetailMember.dart';
import '../../models/button/SizedButton.dart';
import '../../repository/api/ApiReceipt.dart';
import '../../utils/RequestModifyUtil.dart';
import 'ReceiptMemberItem.dart';

class ReceiptMemberList extends StatefulWidget {
  final int groupId;
  final int paymentId;
  final RequestReceiptDetail requestReceiptDetail;
  final Function(bool) modalCallback;

  const ReceiptMemberList({
    Key? key,
    required this.groupId,
    required this.paymentId,
    required this.requestReceiptDetail,
    required this.modalCallback,
  }) : super(key: key);

  @override
  _ReceiptMemberListState createState() => _ReceiptMemberListState();
}

class _ReceiptMemberListState extends State<ReceiptMemberList> {
  late bool allSettled;
  late int settledMembersCount;
  late List<bool> isSettledStates;
  late List<int> amountList;
  late List<RequestReceiptDetailMember> newMemberList;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    newMemberList = widget.requestReceiptDetail.memberList!;
    settledMembersCount =
        newMemberList.where((member) => member.amountDue > 0).length;
    amountList = newMemberList.map((member) => member.amountDue).toList();
    isSettledStates = newMemberList
        .map((member) => member.amountDue > 0 ? true : false)
        .toList();
    allSettled = isSettledStates.every((isSettled) => isSettled);

    isLoaded = true;
  }
  void toggleAll(bool value) {
    setState(() {
      isSettledStates = List<bool>.filled(isSettledStates.length, value);
      if(value == true){
        amountList =(List<int>.filled(amountList.length, (widget.requestReceiptDetail.unitPrice*widget.requestReceiptDetail.count/amountList.length).toInt()));
      }
      else {
        amountList =(List<int>.filled(amountList.length, 0));
      }
      updateAllSettled();
      sendPutRequest();
    });
  }
  void updateAllSettled() {
    settledMembersCount = isSettledStates.where((element) => element).length;
    allSettled = isSettledStates.any((element) => element);
    widget.modalCallback(true);
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? Column(
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
              Container(
                height: 270.h,
                child: isSettledStates.isNotEmpty
                    ? ListView.builder(
                        itemCount:
                            widget.requestReceiptDetail.memberList?.length,
                        itemBuilder: (context, index) {
                          return ReceiptMemberItem(
                            groupId: widget.groupId,
                            paymentId: widget.paymentId,
                            receiptDetailId:
                                widget.requestReceiptDetail.receiptId,
                            requestReceiptDetailMember: newMemberList[index],
                            settleCallback: (bool value) {
                              isSettledStates[index] = value;
                              updateAllSettled();
                            },
                            PersonalSettle: isSettledStates[index],
                            amount: amountList[index],
                            amountCallback: (int value) {
                              amountList[index] = value;
                              amountList = reCalculateAmount(
                                  widget.requestReceiptDetail.count*widget.requestReceiptDetail.unitPrice, amountList,
                                  List<bool>.filled(amountList.length, false));
                              updateAllSettled();
                              sendPutRequest();
                            },
                          );
                        },
                      )
                    : Center(
                        child: Text('멤버가 없습니다.'),
                      ),
              ),
              MoneyRequestDetailBottom(amount: reCalculateRemainder(
                  widget.requestReceiptDetail.count*widget.requestReceiptDetail.unitPrice, amountList))
            ],
          )
        : CircularProgressIndicator();
  }
  void sendPutRequest() {
    print('상세정산 수정 api 요청 가욧');
    List<Map<String, dynamic>> data = List.generate(amountList.length, (index) {
      return {
        "memberId": widget.requestReceiptDetail.memberList?[index].memberId,
        "amountDue": amountList[index],
      };
    });

    putPaymentsReceiptDatil(widget.groupId,widget.paymentId,widget.requestReceiptDetail.receiptId,jsonEncode(data));
  }
}
