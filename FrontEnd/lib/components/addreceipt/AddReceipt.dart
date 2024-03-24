import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/addreceipt/ShowBeforeOcr.dart';
import 'package:front/repository/api/ApiReceipt.dart';
import '../../const/colors/Colors.dart';
import '../../entities/Receipt.dart';

class AddReceipt extends StatefulWidget {
  const AddReceipt({super.key});

  @override
  State<AddReceipt> createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {
  List<Receipt>? receiptData;
  bool isLoading = false;

  void sendReceiptData() async {
    if (receiptData == null || receiptData!.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("영수증 등록"),
          content: Text("영수증을 등록하시겠어요?"),
          actions: <Widget>[
            TextButton(
              child: Text("아니요"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("예"),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                });
                List<Receipt> failedReceipts = [];
                for (var receipt in receiptData!) {
                  final res = await postYjReceipt(1, 1, receipt);
                  if (res.statusCode != 200) {
                    failedReceipts.add(receipt);
                  }
                }
                setState(() {
                  isLoading = false;
                  receiptData = failedReceipts;
                });
                if (failedReceipts.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('모든 영수증이 등록되었습니다.')),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('일부 영수증 등록에 실패했습니다. 다시 시도해주세요.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "영수증 등록",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        actions: [
          TextButton(
            onPressed: receiptData != null && receiptData!.isNotEmpty ? () => sendReceiptData() : null,
            child: Text(
              "추가",
              style: TextStyle(
                color: receiptData != null && receiptData!.isNotEmpty ? TEXT_COLOR : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 50.h),
        child: Column(
          children: [
            isLoading ? Center(child: CircularProgressIndicator()) : Container(),
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
            Expanded(
              child: ShowBeforeOcr(
                onReceiptsChanged: (newData) {
                  setState(
                    () {
                      receiptData = newData;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
