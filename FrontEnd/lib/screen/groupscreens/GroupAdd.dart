import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/components/groups/GroupCalendar.dart';
import 'package:front/components/groups/GroupList.dart';
import 'package:front/components/groups/GroupTextField.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'package:flutter/services.dart';

import '../../entities/Group.dart';

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

  // @override
  // void initState() {
  //   super.initState();
  //   _selectedDay = _focusedDay;
  // }

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

              SizedBox(height: 16.0),
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

              SizedBox(height: 16.0),
              ElevatedButton(onPressed: _saveGroup, child: Text('저장')),
            ],
          ),
        ),
      ),
    );
  }
}
