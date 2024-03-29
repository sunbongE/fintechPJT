import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../repository/api/ApiMySpend.dart';

class MyMoney extends StatefulWidget {
  final String MyAccount;

  const MyMoney({Key? key, required this.MyAccount}) : super(key: key);

  @override
  State<MyMoney> createState() => _MyMoneyState();
}

class _MyMoneyState extends State<MyMoney> {
  List<Map<String, dynamic>> bankInfo = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getMyBankInfo();
  }

  void getMyBankInfo() async {
    setState(() {
      isLoading = true;
    });
    final res = await getMyAccount();
    if (res.data != null && mounted) {
      setState(() {
        bankInfo = List<Map<String, dynamic>>.from(res.data).cast<Map<String, dynamic>>();
        isLoading = false;
      });
    } else if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (widget.MyAccount != null) {
                Clipboard.setData(ClipboardData(text: widget.MyAccount));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('클립보드에 복사되었습니다')),
                );
              }
            },
            child: Text(
              '${widget.MyAccount}',
              style: TextStyle(
                fontSize: 13.sp,
                color: Color(0xff6E6E6E),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          isLoading
              ? SizedBox.shrink()
              : bankInfo.isNotEmpty
                  ? Text(
                      '${NumberFormat('#,###').format(bankInfo[0]['transactionAfterBalance'])}원',
                      style: TextStyle(
                        color: TEXT_COLOR,
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text('데이터를 불러오는데 실패했습니다.'),
        ],
      ),
    );
  }
}
