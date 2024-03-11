import "package:flutter/material.dart";
import 'package:front/models/button/Button.dart';

class GroupList extends StatelessWidget {
  const GroupList({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('그룹 1'),
          onTap: () {

          },
        ),
        ListTile(
          title: Text('그룹 2'),
          onTap: () {

          },
        ),
      ],
    );
  }


  //back에서 groupNames를 받아오기
  // final List<String> groupNames; // 그룹 이름을 담은 리스트
  //
  // const GroupList({Key? key, required this.groupNames}) : super(key: key);
  //
  // Widget build(BuildContext context) {
  //   return ListView.builder(
  //     itemCount: groupNames.length, // 그룹 개수에 따라 리스트 아이템 개수를 동적으로 설정
  //     itemBuilder: (context, index) {
  //       final groupName = groupNames[index];
  //       return ListTile(
  //         title: Text(groupName),
  //         onTap: () {
  //           // 각 그룹을 클릭했을 때의 동작을 정의할 수 있습니다.
  //         },
  //       );
  //     },
  //   );
  // }
}