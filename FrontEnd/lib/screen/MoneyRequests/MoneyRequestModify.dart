import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/MoneyRequestItem.dart';
import 'package:front/components/moneyrequests/RequestMemoInputField.dart';
import 'package:front/entities/Expense.dart';

import '../../components/moneyrequests/MoneyRequestDetailBottom.dart';
import '../../components/moneyrequests/RequestModifyList.dart';
import '../../const/colors/Colors.dart';
import '../../models/button/SizedButton.dart';
import '../../models/button/Toggle.dart';
import '../../components/moneyrequests/RequestMemberList.dart';
import '../../entities/RequestDetail.dart';
import '../../repository/api/ApiMoneyRequest.dart';
import '../../utils/RequestModifyUtil.dart';

class MoneyRequestModify extends StatefulWidget {
  final Expense expense;

  const MoneyRequestModify({Key? key, required this.expense}) : super(key: key);

  @override
  _MoneyRequestModifyState createState() => _MoneyRequestModifyState();
}

class _MoneyRequestModifyState extends State<MoneyRequestModify> {
  late bool isSettledStates;
  late TextEditingController memoController;
  late RequestDetail request;
  late List<int> personalRequestAmount;
  late List<bool> isLockedList;
  late int remainderAmount;

  @override
  void initState() {
    super.initState();
    fetchMyGroupPaymentsDetail();
    memoController = TextEditingController(
      text: widget.expense.memo.toString(),
    );
  }

  void fetchMyGroupPaymentsDetail() async {
    final MyGroupPaymentsDetailJson = await getMyGroupPaymentsDetail(1, 17);
    print(MyGroupPaymentsDetailJson.data);
    if (MyGroupPaymentsDetailJson != null) {
      setState(() {
        request = RequestDetail.fromJson(MyGroupPaymentsDetailJson.data);
        print(request);
        memoController = TextEditingController(
          text: widget.expense.memo.toString(),
        );
        personalRequestAmount =
            request.members.map((member) => member.amount).toList();
        remainderAmount = 5; // 백엔드에서 받아오는 값으로 바뀔 때는 생길 예정
        isLockedList = request.members.map((member) => member.lock).toList();
      });
    } else {
      print("정산 데이터를 불러오는 데 실패했습니다.");
    }
  }

  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정산 수정하기'),
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedButton(
              onPressed: () {},
              btnText: '완료',
              size: ButtonSize.xs,
              borderRadius: 10,
              enable: isModifyButtonEnabled(
                  request.totalPrice, personalRequestAmount, remainderAmount),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MoneyRequestItem(
              expense: widget.expense,
              isToggle: false,
            ),
            if (request != null) ...[
              Row(
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10.w)),
                  Text('메모:'),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5.w)),
                  SizedBox(
                      width: 250.w,
                      child: RequestMemoInputField(
                          controller: memoController,
                          onSubmitted: (String value) {})),
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5.h)),
              Expanded(
                child: SizedBox(
                  height: 400.h,
                  child: RequestModifyList(
                    requestDetail: request,
                    requestAmount: personalRequestAmount,
                    isLockedList: (List<bool> value) {
                      setState(() {
                        isLockedList = value;
                      });
                    },
                    personalAmounts: (List<int> value) {
                      setState(() {
                        personalRequestAmount = reCalculateAmount(
                            request.totalPrice, value, isLockedList);
                        remainderAmount = reCalculateRemainder(
                            request.totalPrice, personalRequestAmount);
                      });
                    },
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10.w)),
              MoneyRequestDetailBottom(
                amount: remainderAmount,
              ),
            ] else ...[
              // request가 아직 초기화되지 않았다면 로딩 인디케이터를 보여줍니다.
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
            Padding(padding: EdgeInsets.symmetric(vertical: 10.w)),
          ],
        ),
      ),
    );
  }
}
