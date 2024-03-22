// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:front/components/groups/GroupList.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:front/const/colors/Colors.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/services.dart';
//
// import '../../models/Group.dart';
//
// class GroupModify extends StatefulWidget {
//   final Group group;
//
//   GroupModify({required this.group});
//
//   @override
//   _GroupModifyState createState() => _GroupModifyState();
// }
//
// class _GroupModifyState extends State<GroupModify> {
//   TextEditingController _titleController = TextEditingController();
//   TextEditingController _descriptionController = TextEditingController();
//   DateTime? _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//   String? _startDateText;
//   String? _endDateText;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDay = _focusedDay;
//     _titleController.text = widget.group.title;
//     _descriptionController.text = widget.group.description;
//     _startDateText = widget.group.startDate;
//     _endDateText = widget.group.endDate;
//     _rangeStart = DateTime.parse(widget.group.startDate);
//     _rangeEnd = DateTime.parse(widget.group.endDate);
//   }
//
//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//       });
//     }
//   }
//
//   void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
//     setState(() {
//       _selectedDay = null;
//       _focusedDay = focusedDay;
//       _rangeStart = start;
//       _rangeEnd = end;
//     });
//   }
//
//   void _modifyGroup() {
//     String startDateText = _rangeStart?.toString().split(' ')[0] ?? '';
//     String endDateText = _rangeEnd?.toString().split(' ')[0] ?? '';
//
//     setState(() {
//       _startDateText = startDateText;
//       _endDateText = endDateText;
//     });
//
//     Group modifiedGroup = Group(
//       title: _titleController.text,
//       description: _descriptionController.text,
//       startDate: _startDateText.toString(),
//       endDate: _endDateText.toString(),
//       groupState: widget.group.groupState, groupMembers: [],
//     );
//
//     List<Group> groups = GroupList.getGroups(context);
//     int index = groups.indexOf(widget.group);
//     if (index != -1) {
//       groups[index] = modifiedGroup;
//     }
//     // GroupList.setGroups(context, groups); // 그룹 목록 업데이트
//
//     Navigator.pop(context, modifiedGroup);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('그룹 수정하기'),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: ListView(
//             children: [
//               TextField(
//                 controller: _titleController,
//                 decoration: InputDecoration(
//                   labelText: '그룹 이름',
//                 ),
//               ),
//               TextField(
//                 controller: _descriptionController,
//                 decoration: InputDecoration(
//                   labelText: '그룹 테마',
//                 ),
//               ),
//               Text('${_rangeStart}'),
//               Text('${_rangeEnd}'),
//
//               SizedBox(height: 16.0),
//               //달력추가
//               Expanded(
//                 child: TableCalendar(
//                   focusedDay: DateTime.now(),
//                   firstDay: DateTime(2024),
//                   lastDay: DateTime(2025),
//                   //선택한 날짜
//                   selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                   // calendarFormat: _calendarFormat,
//                   onDaySelected: _onDaySelected,
//                   //범위 설정
//                   rangeStartDay: _rangeStart,
//                   rangeEndDay: _rangeEnd,
//                   onRangeSelected: _onRangeSelected,
//                   rangeSelectionMode: RangeSelectionMode.toggledOn,
//                   //달력 헤더
//                   headerStyle: HeaderStyle(
//                     titleCentered: true,
//                     formatButtonVisible: false,
//                     titleTextStyle: const TextStyle(
//                       fontSize: 20.0,
//                       color: Colors.black,
//                     ),
//                     headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
//                     leftChevronIcon: const Icon(
//                       Icons.arrow_left,
//                       size: 40.0,
//                     ),
//                     rightChevronIcon: const Icon(
//                       Icons.arrow_right,
//                       size: 40.0,
//                     ),
//                   ),
//                   //달력 내용
//                   calendarStyle: CalendarStyle(
//                     //오늘날짜
//                     isTodayHighlighted: true,
//                     todayDecoration: const BoxDecoration(
//                       color: FOCUS_COLOR,
//                       shape: BoxShape.circle,
//                     ),
//                     //범위
//                     rangeHighlightColor: RANGE_COLOR,
//                     // rangeStartDay 모양 조정
//                     rangeStartDecoration: const BoxDecoration(
//                       color: BUTTON_COLOR,
//                       shape: BoxShape.circle,
//                     ),
//                     // rangeEndDay 모양 조정
//                     rangeEndDecoration: const BoxDecoration(
//                       color: BUTTON_COLOR,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                   onPressed: _modifyGroup,
//                   child: Text('수정완료')
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/FirstInviteModal.dart';
import 'package:front/components/groups/GroupCalendar.dart';
import 'package:front/components/groups/GroupTextField.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../entities/Group.dart';

class GroupModify extends StatefulWidget {
  final Group group;

  GroupModify({Key? key, required this.group}) : super(key: key);

  @override
  _GroupModifyState createState() => _GroupModifyState();
}

class _GroupModifyState extends State<GroupModify> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String? _startDateText;
  String? _endDateText;
  bool groupState = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.group.title);
    _descriptionController =
        TextEditingController(text: widget.group.description);
    _startDateText = widget.group.startDate;
    _endDateText = widget.group.endDate;
    _rangeStart = DateTime.tryParse(_startDateText ?? '');
    _rangeEnd = DateTime.tryParse(_endDateText ?? '');
  }

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

    Group modifiedGroup = Group(
      title: _titleController.text,
      description: _descriptionController.text,
      startDate: _startDateText.toString(),
      endDate: _endDateText.toString(),
      groupState: widget.group.groupState,
      groupMembers: widget.group.groupMembers,
    );
    Navigator.pop(context, modifiedGroup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('그룹 수정하기'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
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
              // 달력
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
