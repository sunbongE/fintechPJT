import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/split/SplitLoading.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:front/screen/groupscreens/GroupItem.dart';
import 'package:lottie/lottie.dart';

import '../../models/FlutterToastMsg.dart';
import '../../repository/api/ApiGroup.dart';
import '../../repository/api/ApiSplit.dart';
import '../../screen/SplitMain.dart';
import '../groups/GroupList.dart';
import '../split/SplitDoing.dart';
import '../split/SplitDone.dart';

class Jjatury extends StatefulWidget {
  final int groupId;
  final int remainder;

  const Jjatury({super.key, required this.groupId, required this.remainder});

  @override
  State<Jjatury> createState() => _JjaturyState();
}

class _JjaturyState extends State<Jjatury> {
  int statusCode = 0;
  String message = '';

  @override
  void initState() {
    super.initState();
    finalRequest();
  }

  void finalRequest() async {
    try {
      Map<String, dynamic> result = await postFinalRequest(widget.groupId);
      setState(() {
        message = result['message'];
        statusCode = result['statusCode'];
      });
      print('Message: $message');
      print('StatusCode: $statusCode');
    } catch (err) {
      print('Error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "자투리 정산에 당첨되셨어요!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            Text(
              "${widget.remainder}원",
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 36.sp,
                  color: PRIMARY_COLOR),
            ),
            Lottie.asset('assets/lotties/jjatury.json'),
            SizedButton(
                btnText: "확인",
                size: ButtonSize.s,
                onPressed: statusCode != 0 && message.isNotEmpty
                    ? () {
                  sendForStatus();
                      }
                    : null),
          ],
        ),
      ),
    );
  }

  void sendForStatus() {
    if (statusCode == 406) {
      FlutterToastMsg("금액 부족한 사람이 있어서 정산이 진행되지 않았습니다.");
      navigateToSplit();
    } else if (message == "OK") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SplitLoading(groupId: widget.groupId)));
    } else if (message == "정산할 내역 없음") {
      //이거 백에서 풀어주나요?
      //어떻게 처리하지?
      FlutterToastMsg("정산할 내역이 없습니다. 다시 확인해주세요");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => GroupItem(groupId: widget.groupId)));
    } else {
      FlutterToastMsg("오류가 발생하였습니다. 다시 시도해주세요");
      buttonSlideAnimationPushAndRemoveUntil(context, 1);
    }
  }

  void navigateToSplit() async {
    String status = await fetchGroupMemberStatus(widget.groupId!);
    Navigator.pop(context);

    var modifiedGroup;
    switch (status) {
      case 'BEFORE':
        modifiedGroup = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GroupItem(groupId: widget.groupId!)),
        );
        break;
      case 'SPLIT':
        modifiedGroup = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SplitMain(groupId: widget.groupId!)),
        );
        break;
      case 'DOING':
        modifiedGroup = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SplitDoing(groupId: widget.groupId!)),
        );
        break;
      case 'DONE':
        modifiedGroup = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SplitDone(groupId: widget.groupId!)),
        );
        break;
      default:
        modifiedGroup = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GroupItem(groupId: widget.groupId!)),
        );
        break;
    }
  }
}
