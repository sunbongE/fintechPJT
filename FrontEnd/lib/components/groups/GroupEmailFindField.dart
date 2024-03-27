import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../entities/Member.dart';
import 'package:front/repository/api/ApiGroup.dart';
import 'dart:convert';

class GroupEmailFindField extends StatefulWidget {
  final TextEditingController controller;

  const GroupEmailFindField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _GroupEmailFindFieldState createState() => _GroupEmailFindFieldState();
}

class _GroupEmailFindFieldState extends State<GroupEmailFindField> {
  final _formKey = GlobalKey<FormState>();
  String? _searchResult;
  List<Member> _searchResults = []; // 검색 결과를 저장할 리스트


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
                    final response = await getMemberByEmail(widget.controller.text);
                    if (response != null) {
                      final Map<String, dynamic> responseData = json.decode(response.data);
                      // 상태를 업데이트하고, 검색 결과를 표시합니다.
                      final Member member = Member.fromJson(responseData);

                      // 상태를 업데이트하고, 검색 결과를 List에 추가합니다.
                      setState(() {
                        _searchResults.add(member);
                        _searchResult = member.name; // 예를 들어 멤버의 이름으로 검색 결과를 표시
                      });
                    } else {
                      setState(() {
                        _searchResult = "멤버를 찾을 수 없습니다.";
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
          Text(_searchResult!, style: TextStyle(fontSize: 16)),
        ],
      ],
    );
  }
}