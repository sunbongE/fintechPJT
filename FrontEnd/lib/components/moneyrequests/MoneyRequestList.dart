import 'package:flutter/material.dart';
import 'package:front/entities/Expense.dart';
import 'MoneyRequestItem.dart';

class MoneyRequestList extends StatefulWidget {
  final List<Expense> expenses;
  final int groupId;
  final Function(bool)? onSuccess;

  MoneyRequestList({Key? key, required this.expenses, required this.groupId, this.onSuccess}) : super(key: key);

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
            MoneyRequestItem(
              expense: widget.expenses[index],
              groupId: widget.groupId,
              clickable: true,
              onSuccess: (value) {
                print('머니리퀘스트리스트 불러와야하는거 아니야??? 콜백아?????');
                widget.onSuccess!(true);
              },
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
