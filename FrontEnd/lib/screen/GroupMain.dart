import "package:flutter/material.dart";
import 'package:front/components/groups/GroupList.dart';
import 'package:front/screen/HomeScreen.dart';
import 'package:front/models/button/GroupAddButton.dart';
import 'package:front/screen/MainPage.dart';
import 'package:front/routes.dart';

class GroupMain extends StatelessWidget {
  const GroupMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text('그룹목록'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              icon: Icon(Icons.backspace_outlined),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: GroupList(),
                ),
              ),
            ),
            GroupAddButton(
            ),
          ],
        ),
      ),
    );
  }
}
