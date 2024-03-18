import 'package:flutter/material.dart';
import 'package:front/models/Expense.dart';

import '../../screen/MoneyRequests/MoneyRequestDetail.dart';
import 'MoneyRequestItem.dart'; // Expense 모델 import

class MoneyRequestList extends StatelessWidget {
  final List<Expense> expenses;

  MoneyRequestList({Key? key, required this.expenses}) : super(key: key){print(expenses.length);}
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MoneyRequestDetail(expense: expenses[index])),
            );
          },
          child: MoneyRequestItem(expense: expenses[index]),
        );
      },
    );
  }
}