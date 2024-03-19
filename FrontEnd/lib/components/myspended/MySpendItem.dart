import 'package:flutter/material.dart';

class MySpendItem extends StatelessWidget {
  final Map<String, dynamic> spendDetail;

  const MySpendItem({Key? key, required this.spendDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(spendDetail['store_name']),
      ),
    );
    ;
  }
}
