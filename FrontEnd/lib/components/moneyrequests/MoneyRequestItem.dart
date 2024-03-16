import 'package:flutter/material.dart';
import 'package:front/components/button/Toggle.dart';
import 'package:front/models/Expense.dart';

class MoneyRequestItem extends StatefulWidget {
  final Expense expense;

  MoneyRequestItem({Key? key, required this.expense}) : super(key: key);

  @override
  _MoneyRequestItemState createState() => _MoneyRequestItemState();
}
class _MoneyRequestItemState extends State<MoneyRequestItem> {
  bool isReceipt = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 368,
      height: 80,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row( // Column 위젯 대신 Row 위젯 사용
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.attach_money,size: 44,),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.expense.place, style: TextStyle(
                      fontSize: 14,
                    )),
                    SizedBox(height: 4),
                    Text('날짜: ${widget.expense.date}', style: TextStyle(fontSize: 12,)),
                    //SizedBox(height: 4),

                  ],
                ),
              ),

              Text('${widget.expense.amount}원', style: TextStyle(fontSize: 18,)),
              SizedBox(width: 4),
              Toggle( // 별도 파일로 분리된 토글 위젯 사용
                initialValue: isReceipt,
                onToggle: (value) {
                  setState(() {
                    isReceipt = value;
                    print('object');
                  });
                },
              ),
              //Text('정산올림: ${expense.isSettled ? "true" : "false"}', style: Theme.of(context).textTheme.bodyText2),
              //SizedBox(height: 4),
              //Text('영수증: ${expense.isReceipt ? "true" : "false"}', style: Theme.of(context).textTheme.bodyText2),
            ],
          ),
        ),
      ),
    );
  }
}