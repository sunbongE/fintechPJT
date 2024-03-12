import "package:flutter/material.dart";
import 'package:front/models/button/StateButton.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/screen/GroupMain.dart'; // Group 클래스를 import
import 'package:front/screen/groupscreens/GroupAdd.dart'; // Group 클래스를 import

//백에서 group정보 받아오면 여기에 넣기
class Group {
  // final String startDate;
  // final String endDate;
  final String title;
  final String description;

  Group({required this.title, required this.description,
    // required this.startDate, required this.endDate,
  });
}

class GroupList extends StatefulWidget {
  // const GroupList({Key? key}) : super(key: key);

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState  extends State<GroupList> {
  String title = "";
  String description = "";
  // String startDate = "";
  // String endDate = "";

  List<Group> groups = [];

  void navigateToGroupAdd() async {
    Group newGroup = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupAdd()),
    );
    if (newGroup != null) {
      setState(() {
        groups.add(newGroup);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(groups[index].title),
            subtitle: Text(groups[index].description),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: navigateToGroupAdd,
        child: Icon(Icons.add),
      ),
    );
  }
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
// }
