import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/myspended/MySpendItem.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/entities/Receipt.dart';
import 'package:intl/intl.dart';
import '../../models/CustomDivider.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../repository/api/ApiMyPage.dart';
import 'GroupSpendItem.dart';

class GroupSpendList extends StatefulWidget {
  final int groupId;

  const GroupSpendList({
    required this.groupId,
    super.key,
  });

  @override
  State<GroupSpendList> createState() => _GroupSpendListState();
}

class _GroupSpendListState extends State<GroupSpendList> {
  List<Map<String, dynamic>> getMySpended = [
    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },
    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },
    {
      "transactionId": 0,
      "transactionDate": "2024-03-26",
      "transactionTime": "22:01:01",
      "transactionType": "string",
      "transactionTypeName": "string",
      "transactionBalance": 0,
      "transactionAfterBalance": 0,
      "transactionSummary": "초돈1",
      "groupId": 32,
      "memo": "memo",
      "receiptEnrolled": false
    },
  ];

  bool isLoading = false;
  int nextPage = 0;
  final int size = 10;
  String option = 'all';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getGroupSpendList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        getGroupSpendList();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getGroupSpendList() async {
    if (isLoading) return;
    isLoading = true;

    Map<String, dynamic> queryParameters = {'page': nextPage, 'size': size, 'option': option};

    try {
      final res = await getGroupSpend(widget.groupId, queryParameters);
      List<Map<String, dynamic>>? receipts = res.data;

      setState(() {
        getMySpended!.addAll(receipts ?? []);
        nextPage++;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      isLoading = false;
    }
  }

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
                      GroupSpendItem(groupId: spend['groupId'], paymentId: spend['transactionId']),
                    );
                    print(spend);
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
                                    spend['transactionDate'],
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
