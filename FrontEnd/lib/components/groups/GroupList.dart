import "package:flutter/material.dart";
import 'package:front/const/colors/Colors.dart';
import 'package:front/screen/groupscreens/GroupAdd.dart'; // Group 클래스를 import
import 'package:front/screen/groupscreens/GroupDetail.dart';

import '../../models/Group.dart';

//백에서 group정보 받아오면 여기에 넣기

class GroupList extends StatefulWidget {
  final List<Group> groups;
  //final List<Group> groups;
  const GroupList({Key? key, required this.groups}) : super(key: key);


  // static List<Group> getGroups(BuildContext context) {
  //   final _GroupListState state = context.findAncestorStateOfType<_GroupListState>()!;
  //   return state.groups;
  // }
  // static void setGroups(BuildContext context, List<Group> updatedGroup) {
  //   final _GroupListState state = context.findAncestorStateOfType<_GroupListState>()!;
  //     state.groups = updatedGroup;
  // }


  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {

  //List<Group> groups = [];

  void navigateToGroupAdd() async {
    Group newGroup = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupAdd()),
    );
    if (newGroup != null) {
      setState(() {
        widget.groups.add(newGroup);
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
        itemCount: widget.groups.length,
        itemBuilder: (context, index) {
          DateTime today = DateTime.now();
          DateTime endDateParsed = DateTime.parse(widget.groups[index].endDate);
          if (today.isAfter(endDateParsed)) {
            widget.groups[index].groupState = true;
          }
          return Card(
            margin: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            color: widget.groups[index].groupState == true ? COMPLETE_COLOR : TRAVELING,
            child: ListTile(
              onTap: () {
                navigateToGroupDetail(widget.groups[index]);
              },
              title: Text(
                widget.groups[index].title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.groups[index].description),
                  Text('시작일: ${widget.groups[index].startDate}'),
                  Text('종료일: ${widget.groups[index].endDate}'),
                ],
              ),
              trailing: widget.groups[index].groupState == true
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