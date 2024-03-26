import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/myspended/MySpendItem.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/entities/Receipt.dart';
import 'package:intl/intl.dart';

import '../../models/CustomDivider.dart';
import '../../models/button/ButtonSlideAnimation.dart';

class MySpendList extends StatefulWidget {
  const MySpendList({
    super.key,
  });

  @override
  State<MySpendList> createState() => _MySpendListState();
}

class _MySpendListState extends State<MySpendList> {
  List<Receipt>? getMySpended = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getMySpended!
            .map((spend) => InkWell(
                  onTap: () {
                    // buttonSlideAnimation(
                    //   context,
                    //   MySpendItem(spend: spend),
                    // );
                    print("ㅠㅠ api 만들어조ㅠ");
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
                                    spend.date,
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                  SizedBox(width: 25.w),
                                  Text(
                                    spend.storeName,
                                    style: TextStyle(fontSize: 20.sp),
                                  ),
                                ],
                              ),
                              Text(
                                '-${NumberFormat('#,###').format(spend.totalPrice)}원',
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
