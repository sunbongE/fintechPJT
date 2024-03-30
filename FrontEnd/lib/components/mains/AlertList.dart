import 'package:flutter/material.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';

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
        scrolledUnderElevation: 0,
        title: Text('알림 리스트'),
        leading: IconButton(
          icon: Icon(Icons.close), // 'X' 아이콘 사용
          onPressed: () {
            // 여기서 buttonSlideAnimationPushAndRemoveUntil 함수 호출
            // 이 예제에서는 함수의 구현이 주어지지 않았으므로 가상의 함수로 가정합니다.
            // 실제 함수명과 매개변수는 필요에 따라 조정해 주세요.
            Navigator.pop(context);
          },
        ),
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
