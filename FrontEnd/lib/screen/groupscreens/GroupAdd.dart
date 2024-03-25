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

  void _saveGroup() async {
    String startDateText = _rangeStart?.toString().split(' ')[0] ?? '';
    String endDateText = _rangeEnd?.toString().split(' ')[0] ?? '';

    Map<String, dynamic> groupData = {
      "groupName": _titleController.text,
      "theme": _descriptionController.text,
      "startDate": startDateText,
      "endDate": endDateText,
    };

    try {
      final response = await postGroupInfo(groupData);
      if (response != null) {
        print("그룹이 성공적으로 생성되었습니다.");

        Group newGroup = Group(
          groupName: _titleController.text,
          theme: _descriptionController.text,
          startDate: startDateText,
          endDate: endDateText,
          groupState: false,
          groupMembers: [],
        );
        Navigator.pop(context, newGroup);
        FirstInviteModal.showInviteModal(context, newGroup);
      } else {
        print("그룹 생성에 실패했습니다.");
      }
    } catch (e) {
      print("그룹 생성 중 에러가 발생했습니다: $e");
    }
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
