import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/intros/TermsPage.dart';
import 'package:front/components/selectbank/AccountList.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';
import 'package:front/providers/store.dart';
import 'package:front/repository/api/ApiLogin.dart';

class SelectAccount extends StatefulWidget {
  final String? selectedBank;

  const SelectAccount({required this.selectedBank, super.key});

  @override
  State<SelectAccount> createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {
  List<Map<String, dynamic>>? accountList = [];
  int? selectedAccountIndex;
  String? selectAccount = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAccounts();
  }

  void getAccounts() async {
    try {
      setState(() {
        isLoading = true;
      });

      // List<Map<String, dynamic>>? getAccounts = await getBankInfo(widget.selectedBank);
      // await Future.delayed(Duration(seconds: 2));

      List<Map<String, dynamic>>? getAccounts = [
        {"idx": 0, "account": "3333-06-2400348"},
        {"idx": 1, "account": "3333-24-8039659"},
        {"idx": 2, "account": "3333-23-6307311"},
        {"idx": 3, "account": "3333-09-6719262"},
        {"idx": 4, "account": "3333-09-6719262"},
        {"idx": 5, "account": "3333-09-6719262"},
        {"idx": 6, "account": "3333-09-6719262"},
        {"idx": 7, "account": "3333-09-6719262"},
      ];

      setState(() {
        isLoading = false;
        accountList = getAccounts.isNotEmpty ? getAccounts : null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 100.h, 0, 30.h),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : accountList == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "선택하신 은행에\n갖고 계신 계좌가 없습니다.",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            height: 2.5.h,
                            letterSpacing: 1.0.w,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Button(
                          btnText: "뒤로 가기",
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              height: 2.5.h,
                              letterSpacing: 1.0.w,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "${widget.selectedBank}에서\n여정과 함께할 계좌를 "),
                              TextSpan(
                                text: "한 개",
                                style: TextStyle(color: TEXT_COLOR),
                              ),
                              TextSpan(text: " 선택해주세요"),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Expanded(
                          child: AccountList(
                            accountList: accountList,
                            selectedAccountIndex: selectedAccountIndex,
                            selectedBank: widget.selectedBank,
                            onSelectAccount: (int index, String account) {
                              setState(() {
                                selectedAccountIndex = index;
                                selectAccount = account;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10.h),
                        selectAccount != ''
                            ? Button(
                                btnText: "Next",
                                onPressed: () async {
                                  // postBankInfo({
                                  //   'selectedAccount': selectAccount,
                                  //   'selectedBank': widget.selectedBank
                                  // });
                                  UserManager().saveUserInfo(
                                    newSelectedBank: widget.selectedBank,
                                    newSelectedAccount: selectAccount,
                                  );
                                  buttonSlideAnimation(context, TermsPage());
                                })
                            : Button(
                                btnText: "계좌을 선택해주세요",
                              ),
                      ],
                    ),
        ),
      ),
    );
  }
}
