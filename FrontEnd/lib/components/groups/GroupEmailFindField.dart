import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupEmailFindInviteMemberCard.dart';
import 'package:front/const/colors/Colors.dart';
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
                      } else {
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
        if (userInfoList.isNotEmpty)
          Container(
            width: 210.w,
            height: 110.h,
            child: ListView.builder(
              shrinkWrap: true, // ListView가 자신의 내용에 맞게 크기를 조정하도록 설정
              scrollDirection: Axis.horizontal,
              itemCount: userInfoList.length, // 수정: userInfoList의 길이 사용
              itemBuilder: (context, index) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.15,
                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  // 좌우 마진 설정
                  child: GroupEmailFindInviteMemberCard(
                      member: userInfoList[index]),
                  // 예시: memberInfo를 사용하여 사용자 정보를 표시하는 위젯을 여기에 구성
                );
              },
            ),
          ),
        TextButton(
          child: Text(
            '초대하기',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            widget.onInvite(inviteMember);
            print(23232323);
            print(inviteMember);
            print(23232323);
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: BUTTON_COLOR,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}
