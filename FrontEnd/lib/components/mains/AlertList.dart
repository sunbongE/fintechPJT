import 'package:flutter/material.dart';

class AlertList extends StatelessWidget {
  const AlertList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> alerts = [
      "알림 1",
      "알림 2",
      "알림 3",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('알림 리스트'),
      ),
      body: ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(alerts[index]),
          );
        },
      ),
    );
  }
}
