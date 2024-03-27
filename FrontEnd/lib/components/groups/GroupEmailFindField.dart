import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../entities/Member.dart';
import 'package:front/repository/api/ApiGroup.dart';
import 'dart:convert';

class GroupEmailFindField extends StatefulWidget {
  final TextEditingController controller;
  // final Function(GroupMember?) onFound;

  const GroupEmailFindField({
    Key? key,
    required this.controller,
    // required this.onFound,
  }) : super(key: key);

  @override
  _GroupEmailFindFieldState createState() => _GroupEmailFindFieldState();
}
class _GroupEmailFindFieldState extends State<GroupEmailFindField> {
  final _formKey = GlobalKey<FormState>();
  Member? _searchResult; // 변경된 부분: String?에서 Member?로 타입 변경

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
                      final response = await getMemberByEmail(widget.controller.text);
                      if (response != null) {
                        setState(() {
                          _searchResult = Member.fromJson(response.data);
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
                      });
                    }
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
        if (_searchResult != null) ...[
          SizedBox(height: 20),
          Text(_searchResult!.name, style: TextStyle(fontSize: 16)),
        ],
      ],
    );
  }
}