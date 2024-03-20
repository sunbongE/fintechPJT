import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/screen/groupscreens/GroupDetail2.dart';
import 'package:front/const/colors/Colors.dart';
import '../../models/Group.dart';
import 'package:email_validator/email_validator.dart';

// fetchMemberInfo 함수의 더미 데이터 구현
Future<Map<String, dynamic>> MemberInfo(String email) async {
  // 더미 데이터 생성
  Map<String, dynamic> dummyMemberInfo = {
    'name': 'John Doe',
    'profileImg': 'https://example.com/profile.jpg',
    'email': '123@naver.com',
  };
  // 1초 대기 후 더미 데이터 반환
  return dummyMemberInfo;
}

class GroupDetail extends StatelessWidget {
  final Group group;

  GroupDetail({required this.group});

  String email = ''; // 초대할 이메일을 저장할 변수
  List<String> friendEmails = []; // 초대된 이메일들을 저장할 리스트

  void sendNotification(String email) {
    // 알림을 보내는 함수
    // 여기에 알림을 보내는 로직
    // 이메일 주소에 해당하는 사용자에게 알림
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
              Column(
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 140), // 왼쪽 공간 비워두기
                        Text(
                          '참여인원',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 100.w), // 왼쪽 공간 비워두기
                        IconButton(
                          icon: Icon(Icons.add), // 아이콘 설정
                          tooltip: '인원 추가', // 사용자에게 버튼의 기능을 설명하는 툴팁 추가
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('친구들을 초대해보세요'),
                                  content: TextField(
                                    onChanged: (value) {
                                      bool isValid = EmailValidator.validate(
                                          value); // 이메일 유효성 검사
                                      if (isValid) {
                                        // 유효한 이메일이라면 변수에 저장
                                        email = value;
                                      } else {
                                        // 유효하지 않은 이메일 형식이면 예외 처리
                                      }
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // 백엔드 API 호출 및 회원 정보 가져오기
                                        MemberInfo(email).then((memberInfo) {
                                          // 회원 정보를 가져온 후 이름과 프로필 이미지를 추출하여 사용합니다.
                                          String name = memberInfo['name'];
                                          String profileImg =
                                              memberInfo['profileImg'];

                                          // 이름과 프로필 이미지를 나열하는 로직을 구현해주세요.
                                          print(
                                              '이름: $name, 프로필 이미지: $profileImg');

                                          // 초대된 이메일을 리스트에 추가
                                          friendEmails.add(email);
                                          print(friendEmails);
                                        });

                                        // 다이얼로그 닫기
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('초대하기'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // 다이얼로그 닫기
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('닫기'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  //Text(group.groupMembers.map((member) => member.name).join(', ')),
                  Center(
                    child: Container(
                      height: 100.h, // Card의 세로 크기를 지정
                      child: ListView(
                        scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                        children: group.groupMembers
                            .map((member) => Card(
                                  child: Container(
                                    width: 100, // Card의 가로 크기를 지정
                                    child: Center(
                                        child: Column(
                                      children: [
                                        Text(member.name),
                                        Text(member.email),
                                      ],
                                    )),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),

              // 정산하기 버튼
              Button(
                btnText: '정산하기',
                onPressed: () {
                  print('컴포넌트쪼개기');
                },
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
              Column(
                children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
