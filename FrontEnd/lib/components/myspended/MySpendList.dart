import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/myspended/MySpendItem.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:intl/intl.dart';

import '../../models/CustomDivider.dart';
import '../../models/button/ButtonSlideAnimation.dart';

class MySpendList extends StatefulWidget {
  const MySpendList({super.key});

  @override
  State<MySpendList> createState() => _MySpendListState();
}

class _MySpendListState extends State<MySpendList> {
  List<Map<String, dynamic>>? getMySpended = [
    {
      "transactionDate": "2024-03-20",
      "transactionTime": "22:01:01",
      "transactionSummary": "초돈8",
      "location": "광주광역시 광산구 장덕동 1437",
      "transactionBalance": 80000,
      "receiptEnrolled": true,
      "details": [
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 40000,
          "count": 1,
          "totalAmount": 40000,
        },
      ],
      "memberList": [
        {"memberId": "string", "totalAmount": 0, "lock": true},
        {"memberId": "string", "totalAmount": 0, "lock": true}
      ]
    },
    {
      "transactionDate": "2024-03-20",
      "transactionTime": "22:01:01",
      "transactionSummary": "초돈7",
      "location": "서울특별시 영등포구 신길로 41라길 13-3",
      "transactionBalance": 865400,
      "receiptEnrolled": false,
      "memberList": [
        {"memberId": "string", "totalAmount": 0, "lock": true},
        {"memberId": "string", "totalAmount": 0, "lock": true}
      ]
    },
    {
      "transactionDate": "2024-03-20",
      "transactionTime": "22:01:01",
      "transactionSummary": "초돈6",
      "location": "전라남도 무안군 삼향읍 대죽동로 40",
      "transactionBalance": 145300,
      "receiptEnrolled": true,
      "details": [
        {
          "menu": "string",
          "price": 60000,
          "count": 2,
          "totalAmount": 120000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 40000,
          "count": 1,
          "totalAmount": 40000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 40000,
          "count": 1,
          "totalAmount": 40000,
        },
      ],
      "memberList": [
        {"memberId": "string", "totalAmount": 0, "lock": true},
        {"memberId": "string", "totalAmount": 0, "lock": true}
      ]
    },
    {
      "transactionDate": "2024-03-20",
      "transactionTime": "22:01:01",
      "transactionSummary": "초돈5",
      "location": "서울특별시 양천구 목동동로 10",
      "transactionBalance": 112300,
      "receiptEnrolled": true,
      "details": [
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 40000,
          "count": 1,
          "totalAmount": 40000,
        },
      ],
      "memberList": [
        {"memberId": "string", "totalAmount": 0, "lock": true},
        {"memberId": "string", "totalAmount": 0, "lock": true}
      ]
    },
    {
      "transactionDate": "2024-03-20",
      "transactionTime": "22:01:01",
      "transactionSummary": "초돈4",
      "location": "광주광역시 광산구 장신로19번안길 5-2",
      "transactionBalance": 1400,
      "receiptEnrolled": true,
      "details": [
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 40000,
          "count": 1,
          "totalAmount": 40000,
        },
      ],
      "memberList": [
        {"memberId": "string", "totalAmount": 0, "lock": true},
        {"memberId": "string", "totalAmount": 0, "lock": true}
      ]
    },
    {
      "transactionDate": "2024-03-20",
      "transactionTime": "22:01:01",
      "transactionSummary": "초돈3",
      "location": "서울특별시 구로구 중앙로 121",
      "transactionBalance": 185400,
      "receiptEnrolled": true,
      "details": [
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 40000,
          "count": 1,
          "totalAmount": 40000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 40000,
          "count": 1,
          "totalAmount": 40000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 40000,
          "count": 1,
          "totalAmount": 40000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 10000,
          "count": 2,
          "totalAmount": 20000,
        },
        {
          "menu": "string",
          "price": 40000,
          "count": 1,
          "totalAmount": 40000,
        },
      ],
      "memberList": [
        {"memberId": "string", "totalAmount": 0, "lock": true},
        {"memberId": "string", "totalAmount": 0, "lock": true}
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getMySpended!
            .map((spend) => InkWell(
                  onTap: () {
                    buttonSlideAnimation(
                      context,
                      MySpendItem(spend: spend),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            10.w,
                            30.h,
                            10.w,
                            30.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${DateFormat('MM.dd').format(DateTime.parse(spend['transactionDate']))}',
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                  SizedBox(width: 25.w),
                                  Text(
                                    spend['transactionSummary'],
                                    style: TextStyle(fontSize: 20.sp),
                                  ),
                                ],
                              ),
                              Text(
                                '-${NumberFormat('#,###').format(spend['transactionBalance'])}원',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: TEXT_COLOR,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      CustomDivider(),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
