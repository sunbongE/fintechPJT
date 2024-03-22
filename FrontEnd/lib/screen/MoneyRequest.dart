import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/addreceipt/AddReceipt.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:front/components/groups/GroupList.dart';
import 'package:front/screen/HomeScreen.dart';

import '../components/moneyrequests/MoneyRequestList.dart';
import '../entities/Expense.dart';
import '../models/button/ButtonSlideAnimation.dart';

class MoneyRequest extends StatefulWidget {
  final groupId;
  const MoneyRequest({super.key, this.groupId});


  @override
  State<MoneyRequest> createState() => _MoneyRequestState();
}

final List <dynamic> rawData = [
  {
    "transactionId": 1,
    "transactionDate": "20240311",
    "transactionTime": "132226",
    "transactionType": null,
    "transactionTypeName": "입금",
    "transactionBalance": 100000,
    "transactionAfterBalance": 100000000000,
    "transactionSummary": "입금합니다",
    "groupId": 1,
    "memo": "\"string\"",
    "receiptEnrolled": false
  },
  {
    "transactionId": 2,
    "transactionDate": "20240311",
    "transactionTime": "132226",
    "transactionType": null,
    "transactionTypeName": "입금",
    "transactionBalance": 1000,
    "transactionAfterBalance": 100000000000,
    "transactionSummary": "입금합니다",
    "groupId": null,
    "memo": "메모22",
    "receiptEnrolled": false
  },
  {
    "transactionId": 3,
    "transactionDate": "20240311",
    "transactionTime": "132226",
    "transactionType": null,
    "transactionTypeName": "입금",
    "transactionBalance": 1000,
    "transactionAfterBalance": 100000000000,
    "transactionSummary": "입금합니다",
    "groupId": null,
    "memo": "\"string\"",
    "receiptEnrolled": false
  },
  {
    "transactionId": 4,
    "transactionDate": "20240311",
    "transactionTime": "132226",
    "transactionType": null,
    "transactionTypeName": "입금",
    "transactionBalance": 1000,
    "transactionAfterBalance": 100000000000,
    "transactionSummary": "입금합니다",
    "groupId": null,
    "memo": "\"string\"",
    "receiptEnrolled": false
  },
  {
    "transactionId": 5,
    "transactionDate": "20240311",
    "transactionTime": "132226",
    "transactionType": null,
    "transactionTypeName": "입금",
    "transactionBalance": 10000,
    "transactionAfterBalance": 100000000000,
    "transactionSummary": "입금합니다",
    "groupId": null,
    "memo": "\"string\"",
    "receiptEnrolled": false
  }
  ];

class _MoneyRequestState extends State<MoneyRequest> {
  @override
  Widget build(BuildContext context) {
    List<Expense> expenses =
        rawData.map((json) => Expense.fromJson(json))
        .toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("내 정산 요청"),
          scrolledUnderElevation: 0,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 2.w)),
                Text('정산할 항목들을 선택해주세요'),
                Padding(padding: EdgeInsets.symmetric(vertical: 5.w)),
                Row(
                  children: [
                    SizedButton(
                      btnText: '영수증 일괄 등록',
                      onPressed: () => buttonSlideAnimation(context, AddReceipt()),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5.w)),
                    SizedButton(
                      btnText: '현금 계산 추가',
                      onPressed: () {
                        print('object');
                      },
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5.w)),
                Expanded(
                  // ListView를 Expanded로 감싸기
                  child: SizedBox(
                    width: 368.w,
                    height: 594.h,
                    child: MoneyRequestList(expenses: expenses),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 20.w)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
