import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/RequestDetail.dart';
import '../button/SizedButton.dart';
import 'RequestMemberItem.dart';

class RequestMemberList extends StatefulWidget {
  final RequestDetail requestDetail;

  const RequestMemberList({Key? key, required this.requestDetail})
      : super(key: key);

  @override
  _RequestMemberListState createState() => _RequestMemberListState();
}

class _RequestMemberListState extends State<RequestMemberList> {
  bool isSettled = false;

  @override
  Widget build(BuildContext context) {
    //isSettled = widget.requestDetail.isSettled;
    return Column(
      children: [
        SizedBox(
          width: 370.w,
          child: Row(
            children: [
              Text(
                '함께한 멤버',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(' | '),
              Text('${widget.requestDetail.members
                  .where((member) => member.isSettled)
                  .length}명'),
              Spacer(),
              SizedButton(
                btnText: '전체선택',
                size: ButtonSize.s,
                borderRadius: 10,
                onPressed: () {
                  print('토글 전체 선택 해제 버튼');
                  // 상태 변경이 필요한 로직 추가
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: ListView.builder(
            itemCount: widget.requestDetail.members.length,
            itemBuilder: (context, index) {
              final member = widget.requestDetail.members[index];
              return RequestMemberItem(
                member: member,
                isSettled: member.isSettled, // 여기서는 멤버별 결제 상태를 사용해야 할 것 같아요.
                onToggle: (value) {
                  // 여기서 멤버별 결제 상태를 업데이트하는 로직을 추가하세요.
                  // 예를 들어, setState를 사용하여 상태를 변경할 수 있습니다.
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
