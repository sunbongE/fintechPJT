import 'package:flutter/material.dart';
import 'package:front/entities/Expense.dart';
import 'MoneyRequestItem.dart';

class MoneyRequestList extends StatefulWidget {
  final List<Expense> expenses;
  final int groupId;

  MoneyRequestList({Key? key, required this.expenses, required this.groupId}) : super(key: key);

  @override
  _MoneyRequestListState createState() => _MoneyRequestListState();
}

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
        return Column(
          children: [
            MoneyRequestItem(expense: widget.expenses[index],groupId: widget.groupId, clickable: true,),
            Container(
              height: 1.0,
              color: Colors.grey.shade300,
            ),
          ],
        );
      },
    );
  }
}
