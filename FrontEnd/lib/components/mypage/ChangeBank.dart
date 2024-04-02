import 'package:flutter/material.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/ChangeAccount.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';
import '../selectbank/BankList.dart';

class ChangeBank extends StatefulWidget {
  const ChangeBank({super.key});

  @override
  State<ChangeBank> createState() => _ChangeBankState();
}

class _ChangeBankState extends State<ChangeBank> {
  Map<String, String> selectedBank = {};

  void onBankSelected(Map<String, String> bank) {
    setState(() {
      selectedBank = bank;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text("계좌 변경"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Center(
          child: buildChangedPage(
              "변경하실 은행을\n한 곳 선택해주세요", "선택한 은행/증권사의\n모든 계좌 내역을 확인할 수 있어요."),
        ),
      ),
    );
  }

  @override
  Widget buildChangedPage(String title, String subTitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EasyRichText(
          title,
          defaultStyle: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            height: 2.5.h,
            letterSpacing: 1.0.w,
          ),
          patternList: [
            EasyRichTextPattern(
              targetString: "한 곳",
              style: TextStyle(color: TEXT_COLOR),
            ),
          ],
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 50.h),
        Text(
          subTitle,
          style:
              TextStyle(fontSize: 16.sp, color: Colors.black.withOpacity(0.8)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30.h),
        Expanded(
          child: BankList(onBankSelected: onBankSelected),
        ),
        SizedBox(height: 10.h),
        selectedBank != ''
            ? Button(
                btnText: "Next",
                onPressed: () => buttonSlideAnimation(
                  context,
                  ChangeAccount(selectedBank: selectedBank),
                ),
              )
            : Button(
                btnText: "은행을 선택해주세요",
              ),
      ],
    );
  }
}
