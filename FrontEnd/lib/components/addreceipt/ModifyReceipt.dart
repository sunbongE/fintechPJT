import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/CustomDivider.dart';
import 'package:intl/intl.dart';
import '../../const/colors/Colors.dart';
import '../../entities/Receipt.dart';
import '../../models/button/SizedButton.dart';

class ModifyReceipt extends StatefulWidget {
  final Receipt receipt;

  ModifyReceipt({Key? key, required this.receipt}) : super(key: key);

  @override
  State<ModifyReceipt> createState() => _ModifyReceiptState();
}

class CustomTextStyle {
  static TextStyle receiptTextStyle(BuildContext context, {bool includeLetterSpacing = true}) {
    return TextStyle(
      fontSize: 16.sp,
      letterSpacing: includeLetterSpacing ? 10.w : null,
      color: RECEIPT_TEXT_COLOR,
    );
  }
}

class CustomMenuStyle {
  static TextStyle receiptTextStyle(BuildContext context, {bool includeLetterSpacing = true}) {
    return TextStyle(
      fontSize: 16.sp,
      color: Colors.black,
    );
  }
}

class CustomResultStyle {
  static TextStyle receiptTextStyle(BuildContext context) {
    return TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.bold);
  }
}

class _ModifyReceiptState extends State<ModifyReceipt> {
  late TextEditingController storeNameController;
  late TextEditingController addressesController;
  late TextEditingController dateFocusNode;
  late List<TextEditingController> nameControllers;
  late List<TextEditingController> countControllers;
  late List<TextEditingController> priceControllers;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    storeNameController = TextEditingController();
    addressesController = TextEditingController();
    dateFocusNode = TextEditingController();
    int itemsLength = widget.receipt.items?.length ?? 0;
    nameControllers = List.generate(itemsLength, (index) => TextEditingController());
    countControllers = List.generate(itemsLength, (index) => TextEditingController());
    priceControllers = List.generate(itemsLength, (index) {
      final controller = TextEditingController();
      controller.addListener(() {
        updateTotalPrice();
      });
      return controller;
    });

    updateTotalPrice();
  }

  void updateTotalPrice() {
    int newTotalPrice = 0;
    for (TextEditingController controller in priceControllers) {
      String text = controller.text.replaceAll(',', '').trim();
      if (text.isNotEmpty) {
        newTotalPrice += int.tryParse(text) ?? 0;
      }
    }
    setState(() {
      totalPrice = newTotalPrice;
    });
  }

  @override
  void dispose() {
    storeNameController.dispose();
    addressesController.dispose();
    dateFocusNode.dispose();
    nameControllers.forEach((controller) => controller.dispose());
    countControllers.forEach((controller) => controller.dispose());
    priceControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "영수증 수정",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(30.0.w),
          child: Column(
            children: [
              Text("YnJ 수정하기",
                  style: TextStyle(
                    fontSize: 40.sp,
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
                        padding: EdgeInsets.all(8.0.w),
                        child: Text(
                          "상호명",
                          style: CustomTextStyle.receiptTextStyle(context),
                        )),
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "${widget.receipt.storeName} ${widget.receipt.subName}",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PRIMARY_COLOR),
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Text(
                          "위치",
                          style: CustomTextStyle.receiptTextStyle(context),
                        )),
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "${widget.receipt.addresses}",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PRIMARY_COLOR),
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Text(
                          "일정",
                          style: CustomTextStyle.receiptTextStyle(context),
                        )),
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "${widget.receipt.date}",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PRIMARY_COLOR),
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
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
                    ].map((e) => Padding(padding: EdgeInsets.all(8.0.w), child: e)).toList(),
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
                children: widget.receipt.items?.isNotEmpty ?? false
                    ? List.generate(widget.receipt.items!.length, (index) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0.h),
                              child: TextField(
                                controller: nameControllers[index],
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: PRIMARY_COLOR),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0.h),
                              child: TextField(
                                controller: countControllers[index],
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: PRIMARY_COLOR),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0.h),
                              child: TextField(
                                controller: priceControllers[index],
                                textAlign: TextAlign.end,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: PRIMARY_COLOR),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
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
                  TableRow(children: [
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "합계금액",
                          style: CustomTextStyle.receiptTextStyle(context),
                        )),
                    Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Text(
                          '${NumberFormat('#,###').format(totalPrice)}원',
                          textAlign: TextAlign.end,
                          style: CustomResultStyle.receiptTextStyle(context),
                        )),
                  ]),
                ],
              ),

              SizedButton(
                btnText: "수정하기",
                onPressed: () {
                  List<Map<String, dynamic>> modifiedItems = [];
                  for (int i = 0; i < nameControllers.length; i++) {
                    modifiedItems.add({
                      'name': nameControllers[i].text,
                      'count': countControllers[i].text,
                      'price': int.tryParse(priceControllers[i].text.replaceAll(',', '').trim()) ?? 0,
                    });
                  }

                  Receipt modifiedReceipt = Receipt(
                    storeName: storeNameController.text,
                    subName: null,
                    addresses: addressesController.text,
                    date: dateFocusNode.text,
                    items: modifiedItems.isNotEmpty ? modifiedItems : null,
                    totalPrice: totalPrice,
                  );

                  Navigator.pop(context, modifiedReceipt);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
