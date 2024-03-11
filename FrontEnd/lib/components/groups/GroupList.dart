import "package:flutter/material.dart";
import 'package:front/models/button/StateButton.dart';
import 'package:front/const/colors/Colors.dart';

List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
List<String> itemContents = [
  'Item 1 Contents',
  'Item 2 Contents',
  'Item 3 Contents',
  'Item 4 Contents'
];

class GroupList extends StatelessWidget {
  const GroupList({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return ListView(
      itemCount: items.length,
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          dense:false,
          horizontalTitleGap: 10,
          title: Text(
            '오늘의 날짜',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          subtitle: Row(
            children: [
              Expanded(
                  child: Text(
                '긔염둥이들',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ))
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          trailing: Button(
            btnText: '여행중',
          ),
          tileColor: TRAVELING,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onTap: () {},
        ),
        ListTile(
          horizontalTitleGap: 10,
          title: Text(
            '오늘의 날짜',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          subtitle: Row(
            children: [
              Expanded(
                  child: Text(
                    '오렌지',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          trailing: Button(
            btnText: '정산중',
          ),
          tileColor: COMPLETE_COLOR,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onTap: () {},
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
