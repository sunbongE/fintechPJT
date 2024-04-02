import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/providers/store.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../repository/api/ApiMyPage.dart';

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getGroupPaylist();
    userManager.loadUserInfo();
  }

  void getGroupPaylist() async {
    setState(() {
      isLoading = true;
    });
    Response res = await getGroupPaymentlist(widget.groupId, widget.paymentId);
    print(res.data);
    setState(() {
      resData = res.data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    userManager.loadUserInfo();

    return isLoading
        ? Lottie.asset("assets/lotties/orangewalking.json")
        : Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: Text(resData['businessName'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp)),
            ),
            body: Padding(
              padding: EdgeInsets.all(30.w),
              child: Column(
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
                        '-${NumberFormat('#,###').format(resData['totalPrice'])}원',
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: TEXT_COLOR),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    children: [
                      Text(
                        '함께한 멤버',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(' | '),
                      Text('${resData['memberList'].length}명'),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: resData['memberList'].length,
                      itemBuilder: (context, index) {
                        final member = resData['memberList'][index];
                        return ListTile(
                          leading: ClipOval(
                            child: SizedBox(
                              width: 60.w,
                              height: 60.h,
                              child: Image.network(member['thumbnailImage'], fit: BoxFit.cover),
                            ),
                          ),
                          title: Text(
                            member['name'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${NumberFormat('#,###').format(member['totalAmount'])}원',
                            style: TextStyle(
                              color: TEXT_COLOR,
                              fontSize: 18.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
