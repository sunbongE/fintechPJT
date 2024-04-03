import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/ChangeBank.dart';
import '../../const/colors/Colors.dart';
import '../../models/button/MyPageBtn.dart';

class MyAccountItem extends StatelessWidget {
  final String? selectedBank;
  final String? selectedAccount;

  const MyAccountItem({
    required this.selectedBank,
    required this.selectedAccount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370.w,
      height: 80.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: BG_COLOR.withOpacity(0.5),
        border: Border.all(color: BG_COLOR, width: 2.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/banks/${selectedBank}.png',
                    width: 50.w,
                    height: 50.h,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${selectedBank}",
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                    Text(
                      '${selectedAccount}',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          MyPageBtn(
            btnText: '변경',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangeBank()),
            ),
          ),
        ],
      ),
    );
  }
}
