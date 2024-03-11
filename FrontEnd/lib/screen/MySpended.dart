import "package:flutter/material.dart";

class MySpended extends StatefulWidget {
  const MySpended({super.key});

  @override
  State<MySpended> createState() => _MySpendedState();
}

class _MySpendedState extends State<MySpended> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ㅎㅇㅎㅇ"),
      ),
      body: Text('MySpended'),
    );
  }
}
