import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/MoneyRequestItem.dart';
import 'package:front/models/Expense.dart';

import '../../components/button/SizedButton.dart';
import '../../components/button/Toggle.dart';
import '../../components/moneyrequests/RequestMemberList.dart';
import '../../models/RequestDetail.dart';

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
        title: Text(widget.expense.place), // 예시로 제목을 AppBar에 표시
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
                  Spacer(),
                  SizedButton(
                    btnText: '메모',
                    size: ButtonSize.s,
                    borderRadius: 10,
                    onPressed: () {
                      print('메모추가버튼누름');
                    },
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5.w)),
            Expanded(
              // ListView를 Expanded로 감싸기
              child: SizedBox(
                //width: 368.w,
                height: 594.h,
                child: RequestMemberList(
                  requestDetail: request,
                  allSettledCallback: updateIsSettledStates,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 20.w)),
          ],
        ),
      ),
    );
  }
}
