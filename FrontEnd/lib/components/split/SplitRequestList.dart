import 'package:flutter/material.dart';
import 'package:front/entities/Expense.dart';
import 'SplitRequestItem.dart';

class SplitRequestList extends StatefulWidget {
  final List<Expense> expenses;
  final int groupId;

  SplitRequestList({Key? key, required this.expenses, required this.groupId})
      : super(key: key);

  @override
  _SplitRequestListState createState() => _SplitRequestListState();
}

class _SplitRequestListState extends State<SplitRequestList> {
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
            SplitRequestItem(
              expense: widget.expenses[index],
              groupId: widget.groupId,
            ),
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
