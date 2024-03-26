import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/myspended/MySpendMap.dart';
import 'package:front/components/myspended/ShowReceiptBtn.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/providers/store.dart';
import 'package:intl/intl.dart';
import '../../entities/Receipt.dart';
import '../../models/CustomDivider.dart';
import '../../repository/api/ApiMyPage.dart';
import '../../screen/YjReceipt.dart';

class GroupSpendItem extends StatefulWidget {
  final int groupId;
  final int paymentId;

  const GroupSpendItem({
    required this.groupId,
    required this.paymentId,
    super.key,
  });

  @override
  State<GroupSpendItem> createState() => _GroupSpendItemState();
}

class _GroupSpendItemState extends State<GroupSpendItem> {
  var userManager = UserManager();
  Map<String, dynamic> resData = {};

  @override
  void initState() {
    super.initState();
    getGroupPaylist();
    userManager.loadUserInfo();
  }

  void getGroupPaylist() async {
    Response res = await getGroupPaymentlist(widget.groupId, widget.paymentId);
    setState(() {
      resData = res.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    userManager.loadUserInfo();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(resData['businessName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "거래시간",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Text(
                      '${resData['transactionDate']} ${resData['transactionTime']}',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "거래금액",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(resData['totalPrice'])}원',
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: TEXT_COLOR),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "결재자",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    Text(
                      '${userManager.name}',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.h,
                ),
                CustomDivider(),
                ShowReceiptBtn(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.8,
                          color: Colors.white,
                          child: Center(
                            // child: YjReceipt(spend: widget.spend),
                          ),
                        );
                      },
                    );
                  },
                ),
                CustomDivider(),
                SizedBox(
                  height: 10.h,
                ),
                MySpendMap(location: resData['location'] ?? "광주 광산구 하남산단6번로 107"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
