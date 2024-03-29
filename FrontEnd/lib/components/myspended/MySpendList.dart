import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/myspended/MySpendItem.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/entities/Receipt.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../models/CustomDivider.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../repository/api/ApiMySpend.dart';

class MySpendList extends StatefulWidget {
  const MySpendList({
    super.key,
  });

  @override
  State<MySpendList> createState() => _MySpendListState();
}

class _MySpendListState extends State<MySpendList> {
  List<Map<String, dynamic>> getMySpended = [];
  bool isLoading = false;

  @override
  void initState() {
    getAccount();
    super.initState();
  }

  void getAccount() async {
    setState(() {
      isLoading = true;
    });
    final res = await getMyAccount();
    print(res.data);
    if (res.data != null) {
      getMySpended = List<Map<String, dynamic>>.from(res.data).cast<Map<String, dynamic>>();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: isLoading
          ? Center(child: Lottie.asset('assets/lotties/orangewalking.json'))
          : Column(
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
                                  20.h,
                                  10.w,
                                  20.h,
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
                                    if (spend['transactionTypeName'] == '입금')
                                      Column(
                                        children: [
                                          Text(
                                            '${NumberFormat('#,###').format(spend['transactionBalance'])}원',
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: TEXT_COLOR,
                                            ),
                                          ),
                                          Text(
                                            '${NumberFormat('#,###').format(spend['transactionAfterBalance'])}원',
                                            style: TextStyle(
                                              color: RECEIPT_TEXT_COLOR,
                                            ),
                                          )
                                        ],
                                      )
                                    else
                                      Column(
                                        children: [
                                          Text(
                                            '-${NumberFormat('#,###').format(spend['transactionBalance'])}원',
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: RECEIPT_TEXT_COLOR,
                                            ),
                                          ),
                                          Text(
                                            '${NumberFormat('#,###').format(spend['transactionAfterBalance'])}원',
                                            style: TextStyle(
                                              color: RECEIPT_TEXT_COLOR,
                                            ),
                                          )
                                        ],
                                      ),
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
