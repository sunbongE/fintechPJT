import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupJoinMemberCarousel.dart';
import 'package:front/const/colors/Colors.dart';
import '../../entities/Group.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';
import 'package:front/entities/GroupMember.dart';
import 'package:front/repository/api/ApiGroup.dart';

class GroupJoinMember extends StatefulWidget {
  final Group group;

  const GroupJoinMember({Key? key, required this.group}) : super(key: key);

  @override
  _GroupJoinMemberState createState() => _GroupJoinMemberState();
}

class _GroupJoinMemberState extends State<GroupJoinMember> {
  List<GroupMember> members = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  void fetchMembers() async {
    setState(() {
      isLoading = true;
    });
    final groupMembersJson = await getGroupMemberList(widget.group.groupId);
    if (groupMembersJson != null) {
      setState(() {
        members = (groupMembersJson.data['groupMembersDtos'] as List)
            .map((item) => GroupMember.fromJson(item))
            .toList();
        isLoading = false;
      });
      // print(groupsJson.data);
    } else {
      setState(() {
        isLoading = false;
      });
      print("그룹 데이터를 불러오는 데 실패했습니다.");
    }

    // print(groupMembersJson.data['groupMembersDtos']);
  }

  // 이메일 추가 로직을 위한 메서드
  void _addMember() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _emailController = TextEditingController();
        final _formKey = GlobalKey<FormState>();
        return AlertDialog(
          title: Text('인원 추가'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: '이메일 입력',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // 백엔드에 이메일 전달 후 데이터 받아오는 로직 추가
                      // 예시에서는 단순화를 위해 바로 ListView에 추가
                      var newMember = GroupMember(
                          name: '새로운 이름',
                          kakaoId: _emailController.text,
                          thumbnailImage: 'dlalwl');
                      setState(() {
                        widget.group.groupMembers.add(newMember);
                      });
                      Navigator.of(context).pop(); // 모달 창 닫기
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _addMember, // 인원 추가 로직 연결
              ),
            ],
          ),
          isLoading // isLoading의 상태에 따라 다른 위젯을 표시
              ? Center(
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20.h),
                      Text("멤버를 불러오고 있습니다"),
                    ],
                  ),
                )
              : GroupJoinMemberCarousel(members: members),
        ],
      ),
    );
  }
}
