import "package:flutter/material.dart";
import 'package:front/const/colors/Colors.dart';
import 'package:front/screen/groupscreens/GroupAdd.dart'; // Group 클래스를 import
import 'package:front/screen/groupscreens/GroupDetail.dart';

//백에서 group정보 받아오면 여기에 넣기
class Group {
  String title;
  String description;
  String startDate;
  String endDate;
  bool groupState;

  Group({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.groupState,
  });
}

class GroupList extends StatefulWidget {

  static List<Group> getGroups(BuildContext context) {
    final _GroupListState state = context.findAncestorStateOfType<_GroupListState>()!;
    return state.groups;
  }
  static void setGroups(BuildContext context, List<Group> updatedGroup) {
    final _GroupListState state = context.findAncestorStateOfType<_GroupListState>()!;
      state.groups = updatedGroup;
  }


  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  String title = "";
  String description = "";
  String startDate = ""; // 시작 날짜를 저장할 변수
  String endDate = ""; // 종료 날짜를 저장할 변수
  bool groupState = false;

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

  void navigateToGroupDetail(Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupDetail(group: group)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          DateTime today = DateTime.now();
          DateTime endDateParsed = DateTime.parse(groups[index].endDate);
          if (today.isAfter(endDateParsed)) {
            groups[index].groupState = true;
          }
          return Card(
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            color: groups[index].groupState == true ? COMPLETE_COLOR : TRAVELING,
            child: ListTile(
              onTap: () {
                navigateToGroupDetail(groups[index]);
              },
              title: Text(
                groups[index].title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(groups[index].description),
                  Text('Start Date: ${groups[index].startDate}'),
                  Text('End Date: ${groups[index].endDate}'),
                ],
              ),
              trailing: groups[index].groupState == true
                  ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: STATE_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '정산중',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              )
                  : Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: STATE_COLOR,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '여행중',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
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