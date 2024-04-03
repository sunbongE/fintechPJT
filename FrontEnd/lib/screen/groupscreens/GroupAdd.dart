import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/GroupCalendar.dart';
import 'package:front/models/button/GroupAddButton2.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart';
import 'package:front/const/colors/Colors.dart';
import '../../models/button/ButtonSlideAnimation.dart';
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


  bool _isFormValid() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _rangeStart != null &&
        _rangeEnd != null;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _isFormValid();
      });
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = start ?? _focusedDay; // 범위의 시작 날짜를 focusedDay로 설정
      _rangeStart = start;
      _rangeEnd = end;
      _isFormValid();
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
      "isCalculateDone": false,
    };

    try {
      final response = await postGroupInfo(groupData);
      if (response != null) {
        print("그룹이 성공적으로 생성되었습니다.");
        // var res = response;

        buttonSlideAnimationPushAndRemoveUntil(context, 1);
        // Navigator.pop(context, newGroup);

        // FirstInviteModal.showInviteModal(context, res);
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
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: '그룹 이름',
                      hintText: '그룹 이름을 입력하세요 (최대 10자)',
                      counterText: '',
                    ),
                    maxLength: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: '테마',
                      hintText: '테마를 입력하세요 (최대 5자)',
                      counterText: '',
                    ),
                    maxLength: 5,
                  ),
                  SizedBox(height: 16.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150.w,
                        child: Card(
                          color: GREY_COLOR,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  _rangeStart != null
                                      ? '출발일:\n ${_rangeStart!.toString().split(' ')[0]}'
                                      : '출발일을\n선택해주세요',
                                  style: TextStyle(
                                      fontSize: 16.0.sp, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.arrow_right),
                          Icon(Icons.arrow_right),
                          Icon(Icons.arrow_right),
                        ],
                      ),
                      SizedBox(
                        width: 150.w,
                        child: Card(
                          color: GREY_COLOR,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  _rangeEnd != null
                                      ? '도착일:\n ${_rangeEnd!.toString().split(' ')[0]}'
                                      : '도착일을\n선택해주세요',
                                  style: TextStyle(
                                      fontSize: 16.0.sp, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0.h),
                  //달력
                  Container(
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
                  GroupAddButton2(
                    onPressed: _isFormValid() ? _saveGroup : null,  // 조건부 활성화
                    btnText: '저장하기',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
