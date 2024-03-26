import 'dart:collection';

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/selectbank/BankList.dart';
import 'package:front/components/selectbank/selectAccount.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';

class SelectBank extends StatefulWidget {
  const SelectBank({super.key});

  @override
  State<SelectBank> createState() => _SelectBankState();
}

class _SelectBankState extends State<SelectBank> {
  Map<String, String> selectedBank = {};

  void onBankSelected(Map<String, String> bank) {
    setState(() {
      selectedBank = bank;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 100.h, 0, 30.h),
          child: Center(
            child: buildSelectPage(
                "여정에 함께할\n은행을 한 곳 선택해주세요", "선택한 은행/증권사의\n모든 계좌 내역을 확인할 수 있어요."),
          ),
        ),
      ),
    );
  }

  Widget buildSelectPage(String title, String subTitle) {
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
        selectedBank != {}
            ? Button(
                btnText: "Next",
                onPressed: () => buttonSlideAnimation(
                  context,
                  SelectAccount(selectedBank: selectedBank),
                ),
              )
            : Button(
                btnText: "은행을 선택해주세요",
              ),
      ],
    );
  }
}
