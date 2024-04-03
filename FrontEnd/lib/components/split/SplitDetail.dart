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
import '../../screen/SplitMain.dart';
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        await Future.delayed(Duration.zero);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => SplitMain(groupId: widget.groupId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = Offset(-1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.type == 'RECEIVE' ? '받을 금액' : '보낼 금액'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
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
                                    size: 100.w,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    "내역이 없습니다",
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      color: Colors.black,
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
      ),
    );
  }
}
