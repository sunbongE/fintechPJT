import 'package:flutter/material.dart';
import 'package:front/models/Expense.dart';
import 'MoneyRequestItem.dart';

class MoneyRequestList extends StatefulWidget {
  final List<Expense> expenses;

  MoneyRequestList({Key? key, required this.expenses}) : super(key: key);

  @override
  _MoneyRequestListState createState() => _MoneyRequestListState();
}

// 상태 관리 클래스
class _MoneyRequestListState extends State<MoneyRequestList> {
  @override
  void initState() {
    super.initState();
    print(widget.expenses.length);
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.expenses.length,
      itemBuilder: (context, index) {
        return MoneyRequestItem(expense: widget.expenses[index]);
      },
    );
  }
}
