import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupJoinMember.dart';
import 'package:front/components/groups/GroupYesCal.dart';
import 'package:front/components/groups/GroupNoCal.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/screen/groupscreens/GroupDetail.dart';
import '../../entities/Group.dart';

// fetchMemberInfo 함수의 더미 데이터 구현
Future<Map<String, dynamic>> MemberInfo(String email) async {
  // 더미 데이터 생성
  Map<String, dynamic> dummyMemberInfo = {
    'name': 'John Doe',
    'profileimg': 'https://example.com/profile.jpg',
    'email': '123@naver.com',
  };
  // 1초 대기 후 더미 데이터 반환
  return dummyMemberInfo;
}

class GroupItem extends StatelessWidget {
  final Group group;

  GroupItem({required this.group});

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
        title: Text(group.groupName),
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
                  builder: (context) => GroupDetail(
                    group: group,
                    onDelete: () {

                      // 여기서 삭제 로직을 구현합니다.
                    },
                  ),
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
              //GroupMember.dart
              GroupJoinMember(group: group),
              // 정산하기 버튼
              Button(
                btnText: '정산하기',
                onPressed: () {
                },
              ),
              //정산요청 내역이 있으면
              // 정산 요청 내역
              GroupYesCal(),
              // 내가 포함된 내역 필터링 버튼
              // 정산 요청 추가하기 버튼
              //정산 요청 내역이 없으면
              GroupNoCal(),
            ],
          ),
        ),
      ),
    );
  }
}
