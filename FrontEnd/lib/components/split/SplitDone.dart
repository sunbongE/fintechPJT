import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/split/SplitResult.dart';
import 'package:front/const/colors/Colors.dart';

import '../../entities/SplitDoneResponse.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../models/button/SizedButton.dart';
import '../../repository/api/ApiSplit.dart';
import 'SplitLoading.dart';

class SplitDone extends StatefulWidget {
  final groupId;
  const SplitDone({super.key, this.groupId});

  @override
  State<SplitDone> createState() => _SplitDoneState();
}

class _SplitDoneState extends State<SplitDone> {
  List<SplitDoneResponse> splitResult = [];
  @override
  void initState() {
    super.initState();
    fetchSplitResult();
  }
  Future<void> fetchSplitResult() async {
    try {
      final response = await getSplitResult(widget.groupId);
      final List<dynamic> responseData = response.data;

      setState(() {
        splitResult = responseData.map((e) => SplitDoneResponse.fromJson(e)).toList();
      });
    } catch (err) {
      print(err);
      throw Exception('최종 결과 조회 실패');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("정산 완료", style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold, color: TEXT_COLOR)),
              Text("여정이 정산을 정리했어요", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 40.h,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: splitResult.length,
                  itemBuilder: (context, index) {
                    return SplitResult(splitResult: splitResult[index]);
                  },
                ),
              ),
              Center(
                child: SizedButton(
                  btnText: "확인",
                  size: ButtonSize.m,
                  onPressed: () => buttonSlideAnimationPushAndRemoveUntil(context, 0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}