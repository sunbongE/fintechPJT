import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../entities/Member.dart';
import 'package:front/repository/api/ApiGroup.dart';

class GroupEmailFindField extends StatefulWidget {
  final TextEditingController controller;
  final groupId;
  final members;
  final Function(List<String>) onInvite;

  const GroupEmailFindField({
    Key? key,
    required this.controller,
    required this.groupId,
    required this.members,
    required this.onInvite,
  }) : super(key: key);

  @override
  _GroupEmailFindFieldState createState() => _GroupEmailFindFieldState();
}

class _GroupEmailFindFieldState extends State<GroupEmailFindField> {
  final _formKey = GlobalKey<FormState>();
  Member? _searchResult;
  List<String> inviteMember = [];
  List<Map<String, dynamic>> userInfoList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: '이메일 입력',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final response =
                          await getMemberByEmail(widget.controller.text);
                      if (response != null) {
                        setState(() {
                          _searchResult = Member.fromJson(response.data);
                          if (_searchResult != null &&
                              _searchResult!.kakaoId != null) {
                            // 그룹 내에 이미 참가된 멤버인지 확인
                            bool isAlreadyMember = widget.members.any(
                                (member) =>
                                    member.kakaoId == _searchResult!.kakaoId);
                            // inviteMember 리스트 내에 이미 존재하는지 확인
                            bool isAlreadyInvited =
                                inviteMember.contains(_searchResult!.kakaoId);

                            if (!isAlreadyMember && !isAlreadyInvited) {
                              userInfoList.add({
                                'name': _searchResult!.name,
                                'thumbnailImage': _searchResult!.thumbnailImage,
                              });
                              inviteMember.add(_searchResult!.kakaoId!);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isAlreadyMember
                                        ? "이미 참가한 멤버입니다"
                                        : "이미 추가한 멤버입니다",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                            }
                            widget.controller.clear();
                          }
                        });
                      }  else {
                        setState(() {
                          _searchResult = null;
                        });
                      }
                    } catch (e) {
                      print("멤버 검색 중 오류 발생: $e");
                      setState(() {
                        _searchResult = null;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("검색된 사람이 없습니다",
                                  style: TextStyle(color: Colors.red))),
                        );
                      });
                    }
                  }
                },
              ),
            ),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !EmailValidator.validate(value)) {
                return '유효한 이메일을 입력해주세요.';
              }
              return null;
            },
          ),
        ),
        // 사용자 정보 리스트를 화면에 표시합니다.
        if (userInfoList.isNotEmpty) ...[
          Container(
            height: 100.h, // 컨테이너 높이 설정
            child: ListView.builder( // 가로 스크롤 가능한 리스트 뷰
              scrollDirection: Axis.horizontal, // 리스트를 가로로 스크롤
              itemCount: userInfoList.length, // 리스트 아이템 개수
              itemBuilder: (context, index) {
                var userInfo = userInfoList[index];
                return Container( // 각 아이템을 위한 컨테이너
                  width: 80.w, // 아이템 너비 설정
                  child: Column( // 이미지와 텍스트를 세로로 배치
                    children: [
                      ClipOval( // 이미지를 동그라미 형태로 클립
                        child: userInfo['thumbnailImage'] != null
                            ? Image.network(
                          userInfo['thumbnailImage'],
                          width: 60.w, // 이미지 너비
                          height: 60.h, // 이미지 높이
                          fit: BoxFit.cover, // 이미지 채우기 방식
                        )
                            : Icon(
                          Icons.account_circle,
                          size: 60, // 아이콘 크기
                        ),
                      ),
                      SizedBox(height: 8.h), // 이미지와 텍스트 사이 여백
                      Text(
                        userInfo['name'],
                        style: TextStyle(fontSize: 16.sp),
                        overflow: TextOverflow.ellipsis, // 텍스트가 넘치면 생략표시
                      ),
                    ],
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10), // 좌우 마진 설정
                );
              },
            ),
          ),
        ],


        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: TextButton(
            child: Text('초대하기'),
            onPressed: () {
              widget
                  .onInvite(inviteMember);
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
