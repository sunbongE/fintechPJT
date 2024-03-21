import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/CustomDivider.dart';
import 'package:intl/intl.dart';
import '../const/colors/Colors.dart';

class YjReceipt extends StatefulWidget {
  final Map<String, dynamic> spend;

  const YjReceipt({Key? key, required this.spend}) : super(key: key);

  @override
  State<YjReceipt> createState() => _YjReceiptState();
}

class CustomTextStyle {
  static TextStyle receiptTextStyle(BuildContext context,
      {bool includeLetterSpacing = true}) {
    return TextStyle(
      fontSize: 16.sp,
      letterSpacing: includeLetterSpacing ? 10.w : null,
      color: RECEIPT_TEXT_COLOR,
    );
  }
}

class CustomResultStyle {
  static TextStyle receiptTextStyle(BuildContext context) {
    return TextStyle(
        fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.bold);
  }
}

class _YjReceiptState extends State<YjReceipt> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("YnJ",
                style: TextStyle(
                  fontSize: 64.sp,
                )),
            SizedBox(height: 30.h),
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
                        "${widget.spend['transactionSummary']}",
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
                        "${widget.spend['location']}",
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
                        '${widget.spend['transactionDate']} ${widget.spend['transactionTime']}',
                        textAlign: TextAlign.end,
                      )),
                ]),
              ],
            ),
            CustomDivider(),
            // 상품명, 단가, 수량, 금액
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  children: [
                    Text(
                      "상품명",
                      style: CustomTextStyle.receiptTextStyle(context),
                    ),
                    Text(
                      "단가",
                      style: CustomTextStyle.receiptTextStyle(context),
                    ),
                    Text(
                      "수량",
                      style: CustomTextStyle.receiptTextStyle(context),
                    ),
                    Text(
                      "금액",
                      style: CustomTextStyle.receiptTextStyle(context),
                    ),
                  ]
                      .map((e) =>
                          Padding(padding: EdgeInsets.all(8.0), child: e))
                      .toList(),
                ),
              ],
            ),
            CustomDivider(),
            // 메뉴, 가격, 수량, 금액(사용자 인풋)
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(3),
              },
              children: widget.spend['receiptEnrolled']
                  ? widget.spend['details'].map<TableRow>((detail) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              detail['menu'],
                              style: CustomTextStyle.receiptTextStyle(context,
                                  includeLetterSpacing: false),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "${detail['price']}",
                              style: CustomTextStyle.receiptTextStyle(context,
                                  includeLetterSpacing: false),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "${detail['count']}",
                              style: CustomTextStyle.receiptTextStyle(context,
                                  includeLetterSpacing: false),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "${detail['totalAmount']}",
                              style:
                                  CustomResultStyle.receiptTextStyle(context),
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
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "-",
                              style: CustomTextStyle.receiptTextStyle(context,
                                  includeLetterSpacing: false),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "-",
                              style: CustomTextStyle.receiptTextStyle(context,
                                  includeLetterSpacing: false),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "-",
                              style: CustomTextStyle.receiptTextStyle(context,
                                  includeLetterSpacing: false),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "-",
                              textAlign: TextAlign.end,
                              style: CustomTextStyle.receiptTextStyle(context,
                                  includeLetterSpacing: false),
                            ),
                          ),
                        ],
                      )
                    ],
            ),
            CustomDivider(),
            // 합계금액, 승인금액, 승인번호
            Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "합계금액",
                        style: CustomTextStyle.receiptTextStyle(context),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '${NumberFormat('#,###').format(widget.spend['transactionBalance'])}원',
                        textAlign: TextAlign.end,
                        style: CustomResultStyle.receiptTextStyle(context),
                      )),
                ]),
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
                        '${NumberFormat('#,###').format(widget.spend['transactionBalance'])}원',
                        textAlign: TextAlign.end,
                        style: CustomResultStyle.receiptTextStyle(context),
                      )),
                ]),
                TableRow(children: [
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "승인번호",
                        style: CustomTextStyle.receiptTextStyle(context),
                      )),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "-",
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
