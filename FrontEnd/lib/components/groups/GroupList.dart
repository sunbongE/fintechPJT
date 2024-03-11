import "package:flutter/material.dart";
import 'package:front/models/button/StateButton.dart';
import 'package:front/const/colors/Colors.dart';


class GroupList extends StatelessWidget {
  const GroupList({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20.0),
      children: [
        Card(
          margin: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: TRAVELING,
          child: ListTile(
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
                  ),
                ),
              ],
            ),
            leading: Padding(
              padding: EdgeInsets.all(8.0),
            ),
            trailing: TravelingButton(
              btnText: '여행중',
            ),
            onTap: () {},
          ),
        ),
        Card(
          margin: EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: COMPLETE_COLOR,
          child: ListTile(
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
                  ),
                ),
              ],
            ),
            leading: Padding(
              padding: EdgeInsets.all(8.0),
            ),
            trailing: TravelingButton(
              btnText: '정산중',
            ),

            onTap: () {

            },
          ),
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
