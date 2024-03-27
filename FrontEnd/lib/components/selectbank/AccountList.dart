import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const/colors/Colors.dart';

class AccountList extends StatefulWidget {
  final List<dynamic>? accountList;
  final int? selectedAccountIndex;
  final Map<String, String> selectedBank;
  final Function(int, String) onSelectAccount;

  const AccountList({
    required this.accountList,
    required this.selectedAccountIndex,
    required this.selectedBank,
    required this.onSelectAccount,
    super.key,
  });

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  int? selectedAccountIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.accountList?.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (selectedAccountIndex == index) {
                selectedAccountIndex = null;
                widget.onSelectAccount(index, '');
              } else {
                selectedAccountIndex = index;
                widget.onSelectAccount(
                    index, widget.accountList?[index]['accountNo'] ?? '');
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.w, 5.h, 30.h, 5.w),
            child: Container(
              width: 370.w,
              height: 80.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: selectedAccountIndex == index
                    ? PRIMARY_COLOR.withOpacity(0.5)
                    : Colors.white,
                border: Border.all(
                  color: Color(0xffD5D5D5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/banks/${widget.selectedBank['name']}.png',
                      width: 50.w,
                      height: 50.h,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${widget.selectedBank['name']}",
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                      Text(
                        widget.accountList?[index]['accountNo'],
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
