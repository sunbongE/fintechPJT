import 'package:flutter/material.dart';
import 'package:front/screen/groupscreens/GroupModify.dart';
import 'package:front/components/groups/GroupList.dart';

import '../../models/Group.dart';

class GroupDetail2 extends StatelessWidget {
  final Group group;
  // final Function(String title) onRemove; // 삭제 콜백 함수 추가

  GroupDetail2({
    required this.group,
    // required this.onRemove,
  });

  void removeGroup(BuildContext context, Group group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('그룹 삭제'),
          content: Text('정말로 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
            ),
            TextButton(
              child: Text('네'),
              onPressed: () {
                // 여기에 그룹 삭제 로직을 구현
                Navigator.of(context).pop(); // 모달 닫기
                Navigator.of(context).pop(); // Detail2 닫기
                Navigator.of(context).pop(); // Detail 닫기
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(group.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group.description,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${group.startDate} ~ ${group.endDate}',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => GroupModify(group: group),
                            //   ),
                            // );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),

                    Divider(
                      height: 16.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16.0),

                    //내가 요청한 정산내역
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '내가 요청한 정산 내역',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.0),

                          Center(
                            child: Text('정보들'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () => removeGroup(context, group),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('그룹 삭제하기'),
            ),
          ),
        ],
      ),
    );
  }
}
