import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:front/components/myspended/MyMoney.dart";
import "../components/myspended/MySpendList.dart";
import "../const/colors/Colors.dart";
import "../providers/store.dart";

class MySpended extends StatefulWidget {
  const MySpended({super.key});

  @override
  State<MySpended> createState() => _MySpendedState();
}

class _MySpendedState extends State<MySpended> {
  var userManager = UserManager();

  @override
  void initState() {
    super.initState();
    userManager.loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          "${userManager.name}의 통장",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        backgroundColor: BG_COLOR,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: 430.w,
              height: 200.h,
              decoration: BoxDecoration(
                color: BG_COLOR,
              ),
              child: MyMoney(
                MyAccount: userManager.selectedAccount!,
              ),
            ),
            // MySpendList(),
          ],
        ),
      ),
    );
  }
}
