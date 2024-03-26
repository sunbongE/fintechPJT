import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/button/Button.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';
import 'package:front/providers/store.dart';
import 'package:front/repository/api/ApiLogin.dart';
import 'package:front/screen/HomeScreen.dart';
import 'package:front/screen/MyPage.dart';

import '../../models/Biometrics.dart';
import '../../models/FlutterToastMsg.dart';
import '../../models/PassWordCertification.dart';
import '../../repository/api/ApiMyPage.dart';
import '../selectbank/AccountList.dart';

class ChangeAccount extends StatefulWidget {
  final Map<String, String> selectedBank;

  const ChangeAccount({required this.selectedBank, super.key});

  @override
  State<ChangeAccount> createState() => _ChangeAccountState();
}

class _ChangeAccountState extends State<ChangeAccount> {
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

      // 한국은행에서 내가 가진 계좌 리스트 get API
      // final res = await getBankInfo(widget.selectedBank);
      // await Future.delayed(Duration(seconds: 2));

      List<Map<String, dynamic>>? getAccounts = [
        {"accountNo": "3333-33-2400348", "balance": 0, "isPrimaryAccount": true, "institutionCode": null},
        {"accountNo": "3333-24-8039659", "balance": 0, "isPrimaryAccount": false, "institutionCode": null},
        {"accountNo": "3333-23-6307311", "balance": 0, "isPrimaryAccount": false, "institutionCode": null},
        {"accountNo": "3333-09-6719262", "balance": 0, "isPrimaryAccount": false, "institutionCode": null},
        {"accountNo": "3333-06-2400348", "balance": 0, "isPrimaryAccount": false, "institutionCode": null},
        {"accountNo": "3333-06-2400348", "balance": 0, "isPrimaryAccount": false, "institutionCode": null},
        {"accountNo": "3333-06-2400348", "balance": 0, "isPrimaryAccount": false, "institutionCode": null},
        {"accountNo": "3333-06-2400348", "balance": 0, "isPrimaryAccount": false, "institutionCode": null},
        {"accountNo": "3333-06-2400348", "balance": 0, "isPrimaryAccount": false, "institutionCode": null},
      ];

      setState(() {
        isLoading = false;
        accountList = getAccounts;
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
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text("계좌 변경"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : accountList == []
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
                                      "${widget.selectedBank['name']}에서\n여정과 함께할 계좌를 "),
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
                            onSelectAccount: (int index, String accountNo) {
                              setState(() {
                                selectedAccountIndex = index;
                                selectAccount = accountNo;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 10.h),
                        selectAccount != ''
                            ? Button(
                                btnText: "Next",
                                onPressed: () async {
                                  bool? authenticated = await CheckBiometrics();
                                  if (authenticated == true) {
                                    FlutterToastMsg("변경이 완료되었습니다.");

                                    Map<String, dynamic> accountInfo = {
                                      "bankCode": widget.selectedBank['code'],
                                      "accountNo": selectAccount,
                                    };

                                    putMyAccount(accountInfo);
                                    UserManager().saveUserInfo(
                                      newSelectedBank: widget.selectedBank['name'],
                                      newSelectedAccount: selectAccount,
                                    );
                                    buttonSlideAnimationPushAndRemoveUntil(context, 3);
                                  } else {
                                    buttonSlideAnimation(
                                      context,
                                      PassWordCertification(
                                        onSuccess: () {
                                          FlutterToastMsg("변경이 완료되었습니다.");

                                          Map<String, dynamic> accountInfo = {
                                            "bankCode": widget.selectedBank['code'],
                                            "accountNo": selectAccount,
                                          };

                                          putMyAccount(accountInfo);
                                          UserManager().saveUserInfo(
                                            newSelectedBank: widget.selectedBank['name'],
                                            newSelectedAccount: selectAccount,
                                          );
                                          buttonSlideAnimationPushAndRemoveUntil(context, 3);
                                        },
                                      ),
                                    );
                                  }
                                },
                              )
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
