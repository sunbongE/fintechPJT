import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/ReceiptMemberList.dart';
import 'package:front/components/moneyrequests/RequestMemberList.dart';
import 'package:front/entities/RequestReceiptDetail.dart';
import 'package:front/entities/RequestReceiptSub.dart';
import 'package:intl/intl.dart';

import '../../const/colors/Colors.dart';
import '../../entities/RequestReceipt.dart';
import '../../entities/RequestReceiptDetailMember.dart';
import '../../repository/api/ApiGroup.dart';
import '../../repository/api/ApiReceipt.dart';

class ReceiptItem extends StatefulWidget {
  final int groupId;
  final int paymentId;
  final RequestReceiptSub requestReceiptSub;

  const ReceiptItem(
      {Key? key,
      required this.requestReceiptSub,
      required this.groupId,
      required this.paymentId})
      : super(key: key);

  @override
  _ReceiptItemState createState() => _ReceiptItemState();
}

class _ReceiptItemState extends State<ReceiptItem> {
  late RequestReceiptDetail requestReceiptDetail;
  bool isLoaded = false;

  void fetchReceiptDetailData({required Function onSuccess}) async {
    final response = await getReceiptDetail(widget.groupId, widget.paymentId,
        widget.requestReceiptSub.receiptDetailId);
    print(response.data);
    var tempRequestReceiptDetail = RequestReceiptDetail.fromJson(response.data);

    if (tempRequestReceiptDetail.memberList == null ||
        tempRequestReceiptDetail.memberList!.isEmpty) {
      final groupMemberResponse = await getGroupMemberList(widget.groupId);
      final groupMembers =
          groupMemberResponse.data['groupMembersDtos'] as List<dynamic>;
      final memberList = groupMembers
          .map((memberJson) => RequestReceiptDetailMember(
              receiptDetailId: widget.requestReceiptSub.receiptDetailId,
              memberId: memberJson['kakaoId'] as String,
              name: memberJson['name'] as String,
              thumbnailImage: memberJson['thumbnailImage'] as String,
              amountDue: 0))
          .toList();
      tempRequestReceiptDetail.memberList = memberList;
    }

    setState(() {
      requestReceiptDetail = tempRequestReceiptDetail;
      isLoaded = true;
    });
    onSuccess();
  }

  void _showDetailsSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            fetchReceiptDetailData(onSuccess: () {
              setModalState(() {
                isLoaded = true;
              });
            });
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.requestReceiptSub.menu,
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '가격 ',
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: '${NumberFormat('#,###').format(widget.requestReceiptSub.price)}원',
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  isLoaded ? ReceiptMemberList(
                    groupId: widget.groupId,
                    paymentId: widget.paymentId,
                    requestReceiptDetail: requestReceiptDetail,
                  ) : CircularProgressIndicator(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showDetailsSheet,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.requestReceiptSub.menu,
                    style: TextStyle(
                        color: Color(0xff201F22),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.requestReceiptSub.count.toString(),
                    style: TextStyle(
                        color: Color(0xff201F22),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${NumberFormat('#,###').format(widget.requestReceiptSub.price)}원',
                    style:
                        TextStyle(fontSize: 20.sp, color: RECEIPT_TEXT_COLOR),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40.w),
            height: 1,
            color: GREY_COLOR,
          ),
        ],
      ),
    );
  }
}
