import 'package:flutter/material.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/screen/GroupMain.dart';

class GroupAdd extends StatelessWidget {
  const GroupAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text('새로운 그룹 만들기'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GroupMain()),
                );
              },
              icon: Icon(Icons.backspace_outlined),
            ),
          ],
        ),

      ),
    );
  }
}