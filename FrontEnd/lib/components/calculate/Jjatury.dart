import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/split/SplitLoading.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';
import 'package:front/models/button/SizedButton.dart';
import 'package:lottie/lottie.dart';

import '../../repository/api/ApiSplit.dart';

class Jjatury extends StatefulWidget {
  final int groupId;
  final int remainder;
  const Jjatury({super.key, required this.groupId, required this.remainder});

  @override
  State<Jjatury> createState() => _JjaturyState();
}

class _JjaturyState extends State<Jjatury> {
  @override
  void initState() {
    super.initState();
    postFinalRequest(widget.groupId);
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
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 36.sp, color: PRIMARY_COLOR),
            ),
            Lottie.asset('assets/lotties/jjatury.json'),
            SizedButton(
              btnText: "확인",
              size: ButtonSize.s,
              onPressed: () => buttonSlideAnimation(context,SplitLoading(groupId: 14,)),
              //onPressed: () => buttonSlideAnimationPushAndRemoveUntil(context, 0),
            )
          ],
        ),
      ),
    );
  }
}
