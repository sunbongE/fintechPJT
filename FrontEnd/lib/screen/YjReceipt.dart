import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/CustomDivider.dart';
import 'package:intl/intl.dart';
import '../const/colors/Colors.dart';
import '../entities/Receipt.dart';

class YjReceipt extends StatefulWidget {
  final Receipt spend;

  const YjReceipt({Key? key, required this.spend}) : super(key: key);

  @override
  State<YjReceipt> createState() => _YjReceiptState();
}

class CustomTextStyle {
  static TextStyle receiptTextStyle(BuildContext context, {bool includeLetterSpacing = true}) {
    return TextStyle(
      fontSize: 16.sp,
      fontFamily: 'IBMPlexSansKR',
      letterSpacing: includeLetterSpacing ? 10.w : null,
      color: RECEIPT_TEXT_COLOR,
    );
  }
}

class CustomMenuStyle {
  static TextStyle receiptTextStyle(BuildContext context, {bool includeLetterSpacing = true}) {
    return TextStyle(
      fontSize: 16.sp,
      fontFamily: 'IBMPlexSansKR',
      color: Colors.black,
    );
  }
}

class CustomResultStyle {
  static TextStyle receiptTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 16.sp,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'IBMPlexSansKR',
    );
  }
}

class _YjReceiptState extends State<YjReceipt> {
  List<TextEditingController> priceControllers = [];
  int approvalAmount = 0;

  @override
  void initState() {
    super.initState();
    calculateTotalAmount();
  }

  void calculateTotalAmount() {
    int totalAmount = 0;
    if (widget.spend.detailList != null) {
      for (var item in widget.spend.detailList!) {
        int price = item['price'];
        totalAmount += price;
      }
    }
    setState(() {
      approvalAmount = totalAmount;
    });

    if (approvalAmount != widget.spend.totalPrice) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('합계금액과 승인금액이 다릅니다.'),
            duration: Duration(seconds: 3),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text("RECEIPT",
                style: TextStyle(
                  fontSize: 40.sp,
                  fontFamily: 'IBMPlexSansKR',
                )),
            SizedBox(height: 20.h),
            // 상호명, 위치, 일정
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "상호명",
                        style: CustomTextStyle.receiptTextStyle(context),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "${widget.spend.businessName} ${widget.spend.subName}",
                        textAlign: TextAlign.end,
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "위치",
                        style: CustomTextStyle.receiptTextStyle(context),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "${widget.spend.location}",
                        textAlign: TextAlign.end,
                        softWrap: true,
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "일정",
                        style: CustomTextStyle.receiptTextStyle(context),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '${widget.spend.date}',
                        textAlign: TextAlign.end,
                      )),
                ]),
              ],
            ),
            CustomDivider(),
            // 상품명, 수량, 금액
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  children: [
                    Text(
                      "상품명",
                      style: CustomTextStyle.receiptTextStyle(context),
                    ),
                    Text(
                      "수량",
                      style: CustomTextStyle.receiptTextStyle(context),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "금액",
                      style: CustomTextStyle.receiptTextStyle(context),
                      textAlign: TextAlign.end,
                    ),
                  ].map((e) => Padding(padding: EdgeInsets.all(8.0), child: e)).toList(),
                ),
              ],
            ),
            CustomDivider(),
            // 메뉴, 수량, 금액(사용자 인풋)
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
              },
              children: widget.spend.detailList?.isNotEmpty ?? false
                  ? widget.spend.detailList!.map<TableRow>((item) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h),
                            child: Text(
                              "${item['menu']}",
                              style: CustomMenuStyle.receiptTextStyle(context, includeLetterSpacing: false),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h),
                            child: Text(
                              "${item['count']}",
                              style: CustomMenuStyle.receiptTextStyle(context, includeLetterSpacing: false),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h),
                            child: Text(
                              '${NumberFormat('#,###').format(item['price'])}원',
                              style: CustomMenuStyle.receiptTextStyle(context, includeLetterSpacing: false),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      );
                    }).toList()
                  : [
                      TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h),
                            child: Text(
                              "-",
                              style: CustomTextStyle.receiptTextStyle(context, includeLetterSpacing: false),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h),
                            child: Text(
                              "-",
                              style: CustomTextStyle.receiptTextStyle(context, includeLetterSpacing: false),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0.h),
                            child: Text(
                              "-",
                              style: CustomTextStyle.receiptTextStyle(context),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
            ),
            CustomDivider(),
            // 합계금액
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(8.0),

                        // 에누리 제외한 물건의 총 금액 => approvalAmount
                        child: Text(
                          "합계금액",
                          style: CustomTextStyle.receiptTextStyle(context),
                        )),
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${NumberFormat('#,###').format(widget.spend.totalPrice)}원',
                          textAlign: TextAlign.end,
                          style: CustomResultStyle.receiptTextStyle(context),
                        )),
                  ],
                ),
                TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "승인금액",
                        style: CustomTextStyle.receiptTextStyle(context),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '${NumberFormat('#,###').format(widget.spend.approvalAmount)}원',
                        textAlign: TextAlign.end,
                        style: CustomResultStyle.receiptTextStyle(context),
                      )),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
