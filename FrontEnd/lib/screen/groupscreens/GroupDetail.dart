import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupList.dart';
import 'package:front/screen/groupscreens/GroupDetail2.dart';
import 'package:front/const/colors/Colors.dart';

import '../../models/Group.dart';

class GroupDetail extends StatelessWidget {
  final Group group;

  GroupDetail({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetail2(group: group),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 참여인원 보기
              Text(
                '참여인원',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //Text(group.groupMembers.map((member) => member.name).join(', ')),
              Center(
                child: Container(
                  height: 100, // Card의 세로 크기를 지정
                  child: ListView(
                    scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                    children: group.groupMembers.map((member) => Card(
                      child: Container(
                        width: 100, // Card의 가로 크기를 지정
                        child: Center(
                          child: Text(member.name),
                        ),
                      ),
                    )).toList(),
                  ),
                ),
              ),

              // 정산하기 버튼
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: BUTTON_COLOR,
                  minimumSize: Size(
                    298,
                    45,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                ),
                child: Text(
                  '정산하기',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //정산요청 내역이 있으면
              // 정산 요청 내역

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '내가 내야 할 것',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // 내가 내야 할 것 버튼 클릭 시 동작할 코드
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BUTTON_COLOR,
                          minimumSize: Size(140, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          '내가 내야 할 것',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // 추가 버튼 클릭 시 동작할 코드
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BUTTON_COLOR,
                          minimumSize: Size(100, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          '추가',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // 내가 포함된 내역 필터링 버튼
              // 정산 요청 추가하기 버튼

              //정산 요청 내역이 없으면
              Container(
                height: 130, // 원하는 높이로 설정
                width: 300, // 원하는 너비로 설정
                child: Card(
                  color: BUTTON_COLOR,
                  child: Column(
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        '여행이 끝나지 않아도',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '정산요청을 할 수 있어요',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      ElevatedButton(
                        onPressed: () {
                          // 요청하기 버튼 클릭 시 동작할 코드
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: STATE_COLOR, // 원하는 배경색으로 변경
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Text(
                          '요청하기',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.0),
              Image.asset(
                'assets/images/empty.png',
                width: 250,
                height: 200,
              ),
              SizedBox(height: 6.0),
              Text(
                '정산 요청이 비어있어요',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
