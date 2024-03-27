import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/CustomDivider.dart';
import 'package:front/models/FlutterToastMsg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../../const/colors/Colors.dart';
import '../../entities/Receipt.dart';
import '../../models/button/SizedButton.dart';
import 'SelectLocation.dart';

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
  // textField 컨트롤러 초기화
  late TextEditingController storeNameController;
  late TextEditingController addressesController;
  late TextEditingController dataController;
  late List<TextEditingController> nameControllers;
  late List<TextEditingController> countControllers;
  late List<TextEditingController> priceControllers;
  int totalPrice = 0;

  @override
  // textField 컨트롤러 생성
  void initState() {
    super.initState();
    storeNameController = TextEditingController(text: widget.receipt.storeName + ' ' + (widget.receipt.subName ?? ''));
    addressesController = TextEditingController(text: widget.receipt.addresses);
    dataController = TextEditingController(text: widget.receipt.date);
    int itemsLength = widget.receipt.items?.length ?? 0;
    nameControllers = List.generate(
      itemsLength,
      (index) => TextEditingController(text: widget.receipt.items?[index]['name']),
    );
    countControllers = List.generate(
      itemsLength,
      (index) => TextEditingController(text: widget.receipt.items?[index]['count'].toString()),
    );
    priceControllers = List.generate(
      itemsLength,
      (index) {
        final controller = TextEditingController(text: widget.receipt.items?[index]['price'].toString());
        controller.addListener(() {
          updateTotalPrice();
        });
        return controller;
      },
    );
    updateTotalPrice();
  }

  // 총 합계를 자동으로 계산하는 코드
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

  // 항목 추가하는 코드
  void addItem() {
    if (_hasEmptyItem()) {
      _showEmptyItemWarning();
      return;
    }
    setState(() {
      nameControllers.add(TextEditingController());
      countControllers.add(TextEditingController());
      priceControllers.add(TextEditingController()..addListener(updateTotalPrice));
      widget.receipt.items?.add({'name': '', 'count': 0, 'price': 0});
    });
  }

  // 저장 시 빈 항목이 있는지 유효성 검사
  bool _hasEmptyItem() {
    for (int i = 0; i < nameControllers.length; i++) {
      String name = nameControllers[i].text.trim();
      String count = countControllers[i].text.trim();
      String price = priceControllers[i].text.trim();
      String storeName = storeNameController.text.trim();
      String address = addressesController.text.trim();
      String data = dataController.text.trim();
      if (name.isEmpty || count.isEmpty || price.isEmpty || storeName.isEmpty || address.isEmpty || data.isEmpty) {
        return true;
      }
    }
    return false;
  }

  // 저장 시 빈 항목이 있으면 경고창
  void _showEmptyItemWarning() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('빈 항목 경고'),
          content: Text('모든 항목을 채워주세요. 모든 항목 중 빈 항목이 있습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 컨트롤러 제거
  @override
  void dispose() {
    storeNameController.dispose();
    addressesController.dispose();
    dataController.dispose();
    nameControllers.forEach((controller) => controller.dispose());
    countControllers.forEach((controller) => controller.dispose());
    priceControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  // appBar에서 뒤로가기 시 저장이 안된다는 알림창
  void _showSaveChangesDialog() {
    if (_hasEmptyItem()) {
      _showEmptyItemWarning();
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('수정 사항 저장'),
          content: Text('현재까지의 수정 사항이 모두 저장됩니다.\n그래도 나가시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('저장'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
        scrolledUnderElevation: 0,
        title: Text(
          "영수증 수정",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _showSaveChangesDialog(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 30.h),
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
                        controller: storeNameController,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PRIMARY_COLOR),
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ]),
                  TableRow(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(8.0.w),
                          child: Text(
                            "위치",
                            style: CustomTextStyle.receiptTextStyle(context),
                          )),
                      Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.map),
                              onPressed: () async {
                                final result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SelectLocation(),
                                  ),
                                );

                                if (result is String) {
                                  addressesController.text = result;
                                }
                              },
                            ),
                            Expanded(
                              child: TextField(
                                controller: addressesController,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(5),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: PRIMARY_COLOR),
                                  ),
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                        controller: dataController,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
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
                  3: FixedColumnWidth(40),
                },
                children: widget.receipt.items?.isNotEmpty ?? false
                    ? widget.receipt.items!.asMap().entries.map<TableRow>((entry) {
                        int index = entry.key;
                        var item = entry.value;
                        return TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5.w),
                              child: TextField(
                                controller: nameControllers[index],
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: PRIMARY_COLOR),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.w),
                              child: TextField(
                                controller: countControllers[index],
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: PRIMARY_COLOR),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5.w),
                              child: TextField(
                                controller: priceControllers[index],
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: PRIMARY_COLOR),
                                  ),
                                  contentPadding: EdgeInsets.all(5),
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: PRIMARY_COLOR),
                              onPressed: () {
                                setState(() {
                                  widget.receipt.items!.removeAt(index);
                                  nameControllers.removeAt(index);
                                  countControllers.removeAt(index);
                                  priceControllers.removeAt(index);
                                  updateTotalPrice();
                                  FlutterToastMsg("항목이 삭제되었습니다.");
                                });
                              },
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
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.grey),
                              onPressed: null,
                            ),
                          ],
                        ),
                      ],
              ),
              // 항목 추가
              TextButton(
                onPressed: () => addItem(),
                child: Icon(
                  Icons.add,
                  color: PRIMARY_COLOR,
                  size: 50.0.sp,
                ),
                style: TextButton.styleFrom(
                  backgroundColor: BG_COLOR,
                  shape: CircleBorder(),
                ),
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
                  if (_hasEmptyItem()) {
                    _showEmptyItemWarning();
                    return;
                  }

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
                    subName: '',
                    addresses: addressesController.text,
                    date: dataController.text,
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
