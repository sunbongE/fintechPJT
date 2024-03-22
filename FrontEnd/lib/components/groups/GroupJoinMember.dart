import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/const/colors/Colors.dart';
import '../../entities/Group.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';
import 'package:front/entities/GroupMember.dart';

class GroupJoinMember extends StatefulWidget {
  final Group group;

  const GroupJoinMember({Key? key, required this.group}) : super(key: key);

  @override
  _GroupJoinMemberState createState() => _GroupJoinMemberState();
}

class _GroupJoinMemberState extends State<GroupJoinMember> {
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
                      var newMember = GroupMember(name: '새로운 이름', email: _emailController.text, profileimg: 'dlalwl');
                      setState(() {
                        widget.group.groupMembers.add(newMember);
                      });
                      Navigator.of(context).pop(); // 모달 창 닫기
                    }
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              tooltip: '인원 추가',
              onPressed: _addMember, // 인원 추가 로직 연결
            ),
          ],
        ),
        Center(
          child: Container(
            height: 100.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.group.groupMembers
                  .map((member) => Card(
                child: Container(
                  width: 100.w,
                  child: Center(
                      child: Column(
                        children: [
                          Text(member.name),
                          Text(member.email),
                          // 이미지 추가 예시
                          // Image.network(member.profileimg),
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




//
// class GroupJoinMember extends StatelessWidget {
//   final Group group;
//
//   const GroupJoinMember({Key? key, required this.group}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end, // 위젯을 오른쪽 끝으로 정렬
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.add), // 아이콘 설정
//               tooltip: '인원 추가', // 사용자에게 버튼의 기능을 설명하는 툴팁 추가
//               onPressed: () {
//                 // 인원 추가 로직
//               },
//             ),
//           ],
//         ),
//         // 나머지 코드는 동일하게 유지
//         Center(
//           child: Container(
//             height: 100.h, // Card의 세로 크기를 지정
//             child: ListView(
//               scrollDirection: Axis.horizontal, // 가로 스크롤 설정
//               children: group.groupMembers
//                   .map((member) => Card(
//                         child: Container(
//                           width: 100.w,
//                           child: Center(
//                               child: Column(
//                             children: [
//                               Text(member.name),
//                               Text(member.email),
//                             ],
//                           )),
//                         ),
//                       ))
//                   .toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
