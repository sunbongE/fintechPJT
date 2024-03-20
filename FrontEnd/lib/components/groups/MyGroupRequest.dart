import 'package:flutter/material.dart';

class MyGroupRequest extends StatelessWidget {
  final String requestDetails;

  const MyGroupRequest({Key? key, required this.requestDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '내가 요청한 정산 내역',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        Center(
          child: Text(requestDetails),
        ),
      ],
    );
  }
}
