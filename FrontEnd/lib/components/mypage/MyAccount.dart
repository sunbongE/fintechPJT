import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/MyAccountItem.dart';
import 'package:lottie/lottie.dart';
import '../../providers/store.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  var userManager = UserManager();
  String? bank;
  String? account;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    await userManager.loadUserInfo();
    setState(() {
      bank = userManager.selectedBank;
      account = userManager.selectedAccount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.w),
      child: bank == null || account == null
          ? Center(child: Lottie.asset('assets/lotties/orangewalking.json'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "여정과 함께하고 있는 계좌",
                  style: TextStyle(fontSize: 20.sp),
                ),
                SizedBox(
                  height: 20.h,
                ),
                MyAccountItem(
                  selectedBank: bank,
                  selectedAccount: account,
                ),
              ],
            ),
    );
  }
}
