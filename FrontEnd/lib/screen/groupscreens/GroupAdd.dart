import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupList.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'package:flutter/services.dart';

import '../../models/Group.dart';

class GroupAdd extends StatefulWidget {
  @override
  _GroupAddState createState() => _GroupAddState();
}

class _GroupAddState extends State<GroupAdd> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String? _startDateText;
  String? _endDateText;
  bool groupState = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _selectedDay = _focusedDay;
  // }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
      });
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = start ?? _selectedDay;
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

    Group newGroup = Group(
      title: _titleController.text,
      description: _descriptionController.text,
      startDate: _startDateText.toString(),
      endDate: _endDateText.toString(),
      groupState: false,
      //처음 만들때는 나를 포함하도록 코드 수정
      groupMembers: [],
    );
    Navigator.pop(context, newGroup);

    // 모달창 띄우기
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('그룹을 만드셨네요!'),
    //       content: Text('링크를 공유해서 친구들을 초대해보세요'),
    //       actions: [
    //         ElevatedButton(
    //           onPressed: () {
    //             // 모달창 닫기
    //             Navigator.pop(context, newGroup);
    //             // 카카오톡 공유 함수 호출
    //             // _kakaoShare();
    //           },
    //           child: Text('공유하기'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }


  // void _kakaoShare() {
  //   bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();
  //
  //   if (isKakaoTalkSharingAvailable) {
  //     print('카카오톡으로 공유 가능');
  //   } else {
  //     print('카카오톡 미설치: 웹 공유 기능 사용 권장');
  //   }
  //   // 카카오링크 SDK 초기화
  //   // KakaoContext.clientId = "애플리케이션 키";
  //
  //   // 카카오링크 메시지 생성
  //   // var template = TextTemplate(
  //   //   text: "링크를 공유해서 친구들을 초대해보세요",
  //   //   link: Link(
  //   //     webUrl: "https://example.com", // 공유할 링크 주소
  //   //   ),
  //   // );
  //
  //   // 카카오링크 메시지 전송
  //   // KakaoLink.instance
  //   //     .sendDefaultTemplate(template)
  //   //     .then((value) => print("카카오톡 메시지 전송 완료"))
  //   //     .catchError((error) => print("카카오톡 메시지 전송 실패: $error"));
  // }


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
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '그룹 이름',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: '그룹 테마',
                ),
              ),
              Text('${_rangeStart}'),
              Text('${_rangeEnd}'),

              SizedBox(height: 16.0),
              //달력추가
              Expanded(
                child: TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime(2024),
                  lastDay: DateTime(2025),
                  //선택한 날짜
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  // calendarFormat: _calendarFormat,
                  onDaySelected: _onDaySelected,
                  //범위 설정
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  onRangeSelected: _onRangeSelected,
                  rangeSelectionMode: RangeSelectionMode.toggledOn,
                  //달력 헤더
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
                    leftChevronIcon: const Icon(
                      Icons.arrow_left,
                      size: 40.0,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.arrow_right,
                      size: 40.0,
                    ),
                  ),
                  //달력 내용
                  calendarStyle: CalendarStyle(
                    //오늘날짜
                    isTodayHighlighted: true,
                    todayDecoration: const BoxDecoration(
                      color: FOCUS_COLOR,
                      shape: BoxShape.circle,
                    ),
                    //범위
                    rangeHighlightColor: RANGE_COLOR,
                    // rangeStartDay 모양 조정
                    rangeStartDecoration: const BoxDecoration(
                      color: BUTTON_COLOR,
                      shape: BoxShape.circle,
                    ),
                    // rangeEndDay 모양 조정
                    rangeEndDecoration: const BoxDecoration(
                      color: BUTTON_COLOR,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: _saveGroup,
                  child: Text('저장')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
