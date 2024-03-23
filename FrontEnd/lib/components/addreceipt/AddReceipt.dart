import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/addreceipt/ShowBeforeOcr.dart';
import '../../const/colors/Colors.dart';

class AddReceipt extends StatefulWidget {
  const AddReceipt({super.key});

  @override
  State<AddReceipt> createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "영수증 등록",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 50.h),
        child: Column(
          children: [
            EasyRichText(
              "영수증은 한번에\n최대 10장까지 등록 가능합니다.",
              defaultStyle: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                height: 2.5.h,
                letterSpacing: 1.0.w,
              ),
              patternList: [
                EasyRichTextPattern(
                  targetString: "최대 10장",
                  style: TextStyle(color: TEXT_COLOR),
                ),
              ],
              textAlign: TextAlign.center,
            ),
            Expanded(child: ShowBeforeOcr()),
          ],
        ),
      ),
    );
  }
}
