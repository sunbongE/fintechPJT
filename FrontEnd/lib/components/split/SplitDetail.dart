import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/split/SplitDoing.dart';
import 'package:front/components/split/SplitRequestList.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:front/providers/store.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../entities/Expense.dart';
import '../../repository/api/ApiSplit.dart';
import '../moneyrequests/MoneyRequestList.dart';

class SplitDetail extends StatefulWidget {
  final int groupId;
  final String type;
  final String memberId;
  final String memberName;

  const SplitDetail(
      {super.key,
      required this.groupId,
      required this.type,
      required this.memberId,
      required this.memberName});

  @override
  _SplitDetailState createState() => _SplitDetailState();
}

class _SplitDetailState extends State<SplitDetail> {
  final UserManager _userManager = UserManager();
  List<Expense> expenseList = [];

  @override
  void initState() {
    super.initState();
    fetchMyGroupPayments();
  }

  void fetchMyGroupPayments() async {
    final MyGroupPaymentsJson =
        await getYeojungDetail(widget.groupId, widget.type, widget.memberId);
    // print(MyGroupPaymentsJson.data);
    if (MyGroupPaymentsJson != null && MyGroupPaymentsJson.data is List) {
      setState(() {
        expenseList = (MyGroupPaymentsJson.data as List)
            .map((item) => Expense.fromJson(item))
            .toList();
        //print(requests);
      });
    } else {
      print("정산 데이터를 불러오는 데 실패했습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'RECEIVE' ? '받을 금액' : '보낼 금액'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 0.h),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.memberName ?? '',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: TEXT_COLOR,
                              ),
                            ),
                            TextSpan(
                              text: widget.type == 'RECEIVE'
                                  ? '님께 요청한 정산 내역입니다'
                                  : '님이 요청한 정산 내역입니다',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    expenseList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 200.h,
                                ),
                                Icon(
                                  Icons.folder_open,
                                  size: 100.w, // 아이콘 크기 조정
                                  color: Colors.grey, // 아이콘 색상 조정
                                ),
                                SizedBox(height: 20.h), // 아이콘과 텍스트 사이의 간격 조정
                                Text(
                                  "내역이 없습니다",
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: Colors.black, // 텍스트 색상 조정
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                      height: 600.h,
                            child: SplitRequestList(
                                expenses: expenseList,
                                groupId: widget.groupId)),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
