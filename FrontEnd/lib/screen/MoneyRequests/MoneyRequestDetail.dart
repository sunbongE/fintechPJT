import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/MoneyRequestItem.dart';
import 'package:front/entities/Expense.dart';

import '../../components/moneyrequests/MoneyRequestDetailBottom.dart';
import '../../const/colors/Colors.dart';
import '../../models/button/SizedButton.dart';
import '../../models/button/Toggle.dart';
import '../../components/moneyrequests/RequestMemberList.dart';
import '../../entities/RequestDetail.dart';

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

  @override
  void initState() {
    super.initState();
    isSettledStates = widget.expense.isSettled;
  }

  void updateIsSettledStates(bool newStates) {
    setState(() {
      isSettledStates = newStates;
      widget.onSuccess(isSettledStates);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> rawData = {
      "장소": "초돈2",
      "금액": 78000,
      "날짜": "2024-05-01",
      "정산올림": true,
      "영수증존재": true,
      "메모": "카공",
      "함께한멤버": [
        {
          "프로필주소": "https://picsum.photos/100/100",
          "이름": "사람1",
          "금액": 4033,
          "정산여부": true
        },
        {
          "프로필주소": "https://picsum.photos/100/100",
          "이름": "사람2",
          "금액": 4033,
          "정산여부": false
        },
        {
          "프로필주소": "https://picsum.photos/100/100",
          "이름": "사람3",
          "금액": 4033,
          "정산여부": true
        }
      ]
    };
    final request = RequestDetail.fromJson(rawData);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense.place),
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedButton(
              btnText: '수정',
              size: ButtonSize.xs,
              borderRadius: 10,
              onPressed: () {
                print('수정버튼누름');
              },
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
            SizedBox(
              width: 343.w,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${request.memo}'),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5.w)),
            Expanded(
              // ListView를 Expanded로 감싸기
              child: SizedBox(
                //width: 368.w,
                height: 400.h,
                child: RequestMemberList(
                  requestDetail: request,
                  allSettledCallback: updateIsSettledStates,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10.w)),
            MoneyRequestDetailBottom(
              amount: widget.expense.amount,
              textColor: TEXT_COLOR, // TEXT_COLOR는 해당 색상 값으로 정의되어 있어야 합니다.
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10.w)),
          ],
        ),
      ),
    );
  }
}
