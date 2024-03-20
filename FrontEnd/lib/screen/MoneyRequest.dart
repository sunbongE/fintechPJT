import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:front/components/groups/GroupList.dart';
import 'package:front/screen/HomeScreen.dart';

import '../components/moneyrequests/MoneyRequestList.dart';
import '../entities/Expense.dart';

class MoneyRequest extends StatefulWidget {
  const MoneyRequest({super.key});

  @override
  State<MoneyRequest> createState() => _MoneyRequestState();
}

final Map<String, dynamic> rawData = {
  "거래목록": [
    {
      "거래번호": 1,
      "장소": "초돈2",
      "금액": 78000,
      "날짜": "2024-05-01",
      "정산올림": true,
      "영수증존재": true
    },
    {
      "거래번호": 2,
      "장소": "초돈3",
      "금액": 20000,
      "날짜": "2024-05-01",
      "정산올림": false,
      "영수증존재": false
    },
    {
      "거래번호": 3,
      "장소": "초돈4",
      "금액": 30000,
      "날짜": "2024-05-01",
      "정산올림": true,
      "영수증존재": false
    },
    {
      "거래번호": 4,
      "장소": "초돈5",
      "금액": 50000,
      "날짜": "2024-05-01",
      "정산올림": false,
      "영수증존재": true
    },
    {
      "거래번호": 5,
      "장소": "초돈5",
      "금액": 50000,
      "날짜": "2024-05-01",
      "정산올림": false,
      "영수증존재": false
    },
    {
      "거래번호": 6,
      "장소": "초돈5",
      "금액": 50000,
      "날짜": "2024-05-01",
      "정산올림": false,
      "영수증존재": false
    },
    {
      "거래번호": 7,
      "장소": "초돈5",
      "금액": 50000,
      "날짜": "2024-05-01",
      "정산올림": false,
      "영수증존재": true
    },
    {
      "거래번호": 8,
      "장소": "초돈5",
      "금액": 50000,
      "날짜": "2024-05-01",
      "정산올림": false,
      "영수증존재": false
    },
    {
      "거래번호": 9,
      "장소": "초돈5",
      "금액": 50000,
      "날짜": "2024-05-01",
      "정산올림": false,
      "영수증존재": true
    },
    {
      "거래번호": 10,
      "장소": "초돈5",
      "금액": 50000,
      "날짜": "2024-05-01",
      "정산올림": false,
      "영수증존재": false
    },
    {
      "거래번호": 11,
      "장소": "초돈5",
      "금액": 50000,
      "날짜": "2024-05-01",
      "정산올림": false,
      "영수증존재": true
    },
    {
      "거래번호": 12,
      "장소": "초돈5",
      "금액": 50000,
      "날짜": "2024-05-01",
      "정산올림": false,
      "영수증존재": true
    },
  ]
};

class _MoneyRequestState extends State<MoneyRequest> {
  @override
  Widget build(BuildContext context) {
    List<Expense> expenses = (rawData['거래목록'] as List<dynamic>)
        .map((json) => Expense.fromJson(json))
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
                      onPressed: () {
                        print('object');
                      },
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
