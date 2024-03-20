import 'package:flutter/material.dart';
import 'package:front/const/colors/Colors.dart';
import '../../entities/Group.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';

class GroupMember extends StatelessWidget {
  final Group group;
  const GroupMember({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                            // if (isValid) {
                            //   // 유효한 이메일이라면 변수에 저장
                            //   email = value;
                            // } else {
                            //   // 유효하지 않은 이메일 형식이면 예외 처리
                            // }
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // 백엔드 API 호출 및 회원 정보 가져오기
                              // MemberInfo(email).then((memberInfo) {
                              //   // 회원 정보를 가져온 후 이름과 프로필 이미지를 추출하여 사용합니다.
                              //   String name = memberInfo['name'];
                              //   String profileImg =
                              //   memberInfo['profileImg'];
                              //
                              //   // 이름과 프로필 이미지를 나열하는 로직을 구현해주세요.
                              //   print(
                              //       '이름: $name, 프로필 이미지: $profileImg');
                              //
                              //   // 초대된 이메일을 리스트에 추가
                              //   friendEmails.add(email);
                              //   print(friendEmails);
                              // }
                              // );

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
    );
  }
}
