import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/ReceiptItem.dart';
import 'package:front/entities/RequestReceipt.dart';
import 'package:intl/intl.dart';
import '../../entities/Expense.dart';
import '../../components/moneyrequests/MoneyRequestItem.dart';
import '../../entities/RequestDetail.dart';
import '../../repository/api/ApiReceipt.dart';

class ReceiptView extends StatefulWidget {
  final Expense expense;
  final int groupId;
  final RequestDetail expenseDetail;
  final bool isSplit;

  ReceiptView(
      {Key? key,
      required this.expense,
      required this.groupId,
      required this.expenseDetail,
      this.isSplit = false})
      : super(key: key);

  @override
  _ReceiptViewState createState() => _ReceiptViewState();
}

class _ReceiptViewState extends State<ReceiptView> {
  RequestReceipt? newRequest;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    print(widget.expense.toString());
    print(widget.expenseDetail.toString());
    print(widget.groupId);
    fetchReceiptData();
  }

  void fetchReceiptData() async {
    final response = await getReceipt(widget.groupId,
        widget.expense.transactionId, widget.expenseDetail.receiptId);
    print(response.data);
    setState(() {
      newRequest = RequestReceipt.fromJson(response.data);
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('영수증 보기'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Column(
        children: [
          MoneyRequestItem(
            expense: widget.expense,
            isToggle: false,
            groupId: widget.groupId,
            clickable: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 45.w, vertical: 8.h),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text('품목',
                                  style: TextStyle(fontSize: 16.sp))),
                          Expanded(
                              child: Text('개수',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ))),
                          Expanded(
                              child: Text('가격',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ))),
                        ],
                      ),
                    ),
                    Divider(thickness: 1.0),
                    if (newRequest != null)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: newRequest?.detailList.length,
                        itemBuilder: (context, index) {
                          return ReceiptItem(
                              requestReceiptSub: newRequest!.detailList[index],
                              groupId: widget.groupId,
                              paymentId: widget.expense.transactionId,
                              isSplit: widget.isSplit);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
