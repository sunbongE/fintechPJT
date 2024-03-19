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
    {"date": "2024-02-08", "store_name": "초돈8", 'cost': 6543000},
    {"date": "2024-02-07", "store_name": "초돈7", 'cost': 865400},
    {"date": "2024-02-06", "store_name": "초돈6", 'cost': 145300},
    {"date": "2024-02-05", "store_name": "초돈5", 'cost': 112300},
    {"date": "2024-02-04", "store_name": "초돈4", 'cost': 1400},
    {"date": "2024-02-03", "store_name": "초돈3", 'cost': 185400},
    {"date": "2024-02-02", "store_name": "초돈2", 'cost': 30000},
    {"date": "2024-02-01", "store_name": "초돈1", 'cost': 155400},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getMySpended!
            .map((spend) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MySpendItem(spendDetail: spend),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
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
                                  '${DateFormat('MM.dd').format(DateTime.parse(spend['date']))}',
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
