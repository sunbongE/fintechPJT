import 'package:flutter/material.dart';
import 'package:front/components/intros/KeyBoardBoard.dart';
import 'package:front/components/intros/KeyBoardKey.dart';
import 'package:front/models/button/Button.dart';

class CreatePwPage extends StatefulWidget {
  const CreatePwPage({super.key});

  @override
  State<CreatePwPage> createState() => _CreatePwPageState();
}

class _CreatePwPageState extends State<CreatePwPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text(
              "여정에서 사용할\n비밀번호를 설정하세요",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "숫자 6자리",
              style:
                  TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.8)),
            ),
            Expanded(child: KeyBoardBoard()),
          ],
        ),
      ),
    );
  }
}
