import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/FirstInviteModal.dart';
import 'package:front/components/groups/GroupCalendar.dart';
import 'package:front/components/groups/GroupTextField.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import '../../entities/Group.dart';
import 'package:front/repository/api/ApiGroup.dart';


class GroupAdd extends StatefulWidget {
  @override
  _GroupAddState createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String? _startDateText;
  String? _endDateText;
  bool groupState = false;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = start ?? _focusedDay; // 범위의 시작 날짜를 focusedDay로 설정
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  void _saveGroup() {
    String startDateText = _rangeStart?.toString().split(' ')[0] ?? '';
    String endDateText = _rangeEnd?.toString().split(' ')[0] ?? '';

    setState(() {
      _startDateText = startDateText;
      _endDateText = endDateText;
    });

    // // 서버에 전송할 데이터를 Map 형태로 준비합니다.
    // Map<String, dynamic> groupData = {
    //   'title': _titleController.text,
    //   'description': _descriptionController.text,
    //   'startDate': startDateText,
    //   'endDate': endDateText,
    //   'groupState': groupState,
    //   'groupMembers': [], // 실제 멤버 정보를 추가할 수 있습니다.
    // };
    //
    // // ApiGroup 클래스의 postGroupInfo 함수를 호출하여 서버에 데이터를 전송합니다.
    // var response = await ApiGroup().postGroupInfo(groupData);
    //
    // // 서버로부터의 응답을 처리합니다. (예: 성공/실패 메시지 표시)
    // if (response != null) {
    //   // 성공적으로 그룹이 생성되었을 때의 처리를 추가합니다.
    //   Navigator.pop(context, response); // 예시로 응답 결과를 이전 화면으로 전달하고 있습니다.
    //   FirstInviteModal.showInviteModal(context, response); // 모달창 띄우기
    // } else {
    //   // 그룹 생성 실패 시의 처리를 추가합니다.
    //   print('그룹 생성 실패');
    // }
    Group newGroup = Group(
      title: _titleController.text,
      description: _descriptionController.text,
      startDate: _startDateText.toString(),
      endDate: _endDateText.toString(),
      groupState: false,
      groupMembers: [],
    );
    Navigator.pop(context, newGroup);

    // 모달창 띄우기 - FirstInviteModal 클래스의 함수를 호출
    FirstInviteModal.showInviteModal(context, newGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('그룹 추가하기'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // 기존 TextField 위젯 대신 GroupTextField 위젯을 사용
              GroupTextField(
                controller: _titleController,
                labelText: '그룹 이름',
              ),
              GroupTextField(
                controller: _descriptionController,
                labelText: '그룹 테마',
              ),
              Text('${_rangeStart}'),
              Text('${_rangeEnd}'),
              SizedBox(height: 16.0.h),
              //달력
              Expanded(
                child: GroupCalendar(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  rangeStart: _rangeStart,
                  rangeEnd: _rangeEnd,
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                ),
              ),
              SizedBox(height: 16.0.h),
              ElevatedButton(onPressed: _saveGroup, child: Text('저장')),
            ],
          ),
        ),
      ),
    );
  }
}
