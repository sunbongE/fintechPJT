import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/myspended/MySpendItem.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:intl/intl.dart';

class MySpendList extends StatefulWidget {
  const MySpendList({super.key});

  @override
  State<MySpendList> createState() => _MySpendListState();
}

class _MySpendListState extends State<MySpendList> {
  List<Map<String, dynamic>>? getMySpended = [
    {
      "transactionDate": "2024-03-20",
      "transactionTime": {
        "hour": 18,
        "minute": 29,
        "second": 20,
        "nano": 0
      },
      "store_name": "초돈8",
      "location": "광주광역시 광산구 장덕동 1437",
      "cost": 6543000,
      "receipt": true,
      "details": "고기, 맥주",
      "participants": ["이영희", "박민수"]
    },
    {
      "transactionDate": "2024-03-20",
      "transactionTime": {
        "hour": 18,
        "minute": 29,
        "second": 20,
        "nano": 0
      },
      "store_name": "초돈7",
      "location": "경기도 수원시 영통구 영통로 290번길 25",
      "cost": 865400,
      "receipt": false,
      "participants": ["이영희", "박민수"]
    },
    {
      "transactionDate": "2024-03-20",
      "transactionTime": {
        "hour": 18,
        "minute": 29,
        "second": 20,
        "nano": 0
      },
      "store_name": "초돈6",
      "location": "전라남도 무안군 삼향읍 대죽동로 40",
      "cost": 145300,
      "receipt": false,
      "details": "고기, 소주",
      "participants": ["이영희", "박민수"]
    },
    {
      "transactionDate": "2024-03-20",
      "transactionTime": {
        "hour": 18,
        "minute": 29,
        "second": 20,
        "nano": 0
      },
      "store_name": "초돈5",
      "location": "서울특별시 양천구 목동동로 10",
      "cost": 112300,
      "receipt": true,
      "details": "고기, 김치찌개",
      "participants": ["이영희", "박민수"]
    },
    {
      "transactionDate": "2024-03-20",
      "transactionTime": {
        "hour": 18,
        "minute": 29,
        "second": 20,
        "nano": 0
      },
      "store_name": "초돈4",
      "location": "광주광역시 광산구 장신로19번안길 5-2",
      "cost": 1400,
      "receipt": true,
      "details": "고기, 맥주",
      "participants": ["이영희", "박민수"]
    },
    {
      "transactionDate": "2024-03-20",
      "transactionTime": {
        "hour": 18,
        "minute": 29,
        "second": 20,
        "nano": 0
      },
      "store_name": "초돈3",
      "location": "서울특별시 구로구 중앙로 121",
      "cost": 185400,
      "receipt": true,
      "details": "고기, 맥주",
      "participants": ["이영희", "박민수"]
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MySpendItem(spend: spend),
                      ),
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
                                    spend['store_name'],
                                    style: TextStyle(fontSize: 20.sp),
                                  ),
                                ],
                              ),
                              Text(
                                '-${NumberFormat('#,###').format(spend['cost'])}원',
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
                      Divider(
                        color: GREY_COLOR,
                        height: 0,
                        thickness: 1.sp,
                        indent: 20.w,
                        endIndent: 20.w,
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
