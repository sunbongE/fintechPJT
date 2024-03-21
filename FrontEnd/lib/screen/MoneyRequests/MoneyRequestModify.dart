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
    memoController = TextEditingController(
      text: widget.expense.memo.toString(),
    );
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
    request = RequestDetail.fromJson(rawData);
    personalRequestAmount =
        request.members.map((member) => member.amount).toList();
    remainderAmount = 5; //백엔드에서 받아오는 값으로 바뀔 때는 생길 예정
    isLockedList = List<bool>.filled(request.members.length, false);
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
              btnText: '완료',
              size: ButtonSize.xs,
              borderRadius: 10,
              enable: isModifyButtonEnabled(
                  request.amount, personalRequestAmount, remainderAmount),
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
                      personalRequestAmount = value;
                    });
                  },
                ),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10.w)),
            MoneyRequestDetailBottom(
              amount: remainderAmount,
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10.w)),
          ],
        ),
      ),
    );
  }
}
