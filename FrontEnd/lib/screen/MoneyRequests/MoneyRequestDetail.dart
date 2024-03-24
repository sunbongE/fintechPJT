import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/MoneyRequestItem.dart';
import 'package:front/entities/Expense.dart';
import 'package:front/screen/MoneyRequests/MoneyRequestModify.dart';

import '../../components/moneyrequests/MoneyRequestDetailBottom.dart';
import '../../const/colors/Colors.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../models/button/SizedButton.dart';
import '../../models/button/Toggle.dart';
import '../../components/moneyrequests/RequestMemberList.dart';
import '../../entities/RequestDetail.dart';
import '../../repository/api/ApiMoneyRequest.dart';

class MoneyRequestDetail extends StatefulWidget {
  final Function onSuccess;
  final Expense expense;

  const MoneyRequestDetail(
      {Key? key, required this.expense, required this.onSuccess})
      : super(key: key);

  @override
  _MoneyRequestDetailState createState() => _MoneyRequestDetailState();
}

class _MoneyRequestDetailState extends State<MoneyRequestDetail> {
  late bool isSettledStates;
  late List<int> amounts;
  RequestDetail request = RequestDetail.empty();

  @override
  void initState() {
    super.initState();
    isSettledStates = widget.expense.isSettled;
    fetchMyGroupPaymentsDetail();
  }

  void fetchMyGroupPaymentsDetail() async {
    final MyGroupPaymentsDetailJson = await getMyGroupPaymentsDetail(1, 17);
    //print(MyGroupPaymentsDetailJson.data);
    if (MyGroupPaymentsDetailJson != null) {
      setState(() {
        request = RequestDetail.fromJson(MyGroupPaymentsDetailJson.data);
        amounts = request.members.map((member) => member.amount).toList();
        //print(amounts);
      });
    } else {
      print("정산 데이터를 불러오는 데 실패했습니다.");
    }
  }

  void updateIsSettledStates(bool newStates) {
    setState(() {
      isSettledStates = newStates;
      widget.onSuccess(isSettledStates);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense.transactionSummary),
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedButton(
              btnText: '수정',
              size: ButtonSize.xs,
              borderRadius: 10,
              onPressed: () =>
                  buttonSlideAnimation(
                    context,
                    MoneyRequestModify(
                      expense: widget.expense,
                    ),
                  ),
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
            if (request.members.isNotEmpty) ...[
              SizedBox(
                width: 343.w,
                child: Row(
                  children: [
                    Text('${request.memo}'),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5.w)),
              Expanded(
                child: SizedBox(
                  //width: 368.w,
                  height: 400.h,
                  child: RequestMemberList(
                    requestDetail: request,
                    allSettledCallback: updateIsSettledStates,
                    callbackAmountList: (List<int> value)
                    { },
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10.w)),
              MoneyRequestDetailBottom(
                amount: widget.expense.transactionBalance,
              ),
            ] else
              ...[
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
