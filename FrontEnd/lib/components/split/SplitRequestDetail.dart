import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/MoneyRequestItem.dart';
import 'package:front/entities/Expense.dart';
import 'package:front/screen/MoneyRequests/MoneyRequestModify.dart';
import 'package:lottie/lottie.dart';

import '../../components/addreceipt/AddReceipt.dart';
import '../../components/moneyrequests/MoneyRequestDetailBottom.dart';
import '../../const/colors/Colors.dart';
import '../../entities/RequestDetailModifyRequest.dart';
import '../../entities/RequestMember.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../models/button/SizedButton.dart';
import '../../models/button/Toggle.dart';
import '../../components/moneyrequests/RequestMemberList.dart';
import '../../entities/RequestDetail.dart';
import '../../repository/api/ApiMoneyRequest.dart';
import '../../screen/MoneyRequests/ReceiptView.dart';
import '../../screen/groupscreens/GroupItem.dart';
import '../../utils/RequestModifyUtil.dart';

class SplitRequestDetail extends StatefulWidget {
  final Function onSuccess;
  final Expense expense;
  final int groupId;

  const SplitRequestDetail({Key? key, required this.expense, required this.onSuccess, required this.groupId}) : super(key: key);

  @override
  _SplitRequestDetailState createState() => _SplitRequestDetailState();
}

class _SplitRequestDetailState extends State<SplitRequestDetail> {
  late bool isSettledStates;
  late List<int> amounts;
  int remainderAmount = 0;
  RequestDetail request = RequestDetail.empty();
  List<bool> isLockedList = [];
  bool isEditable = true;

  @override
  void initState() {
    super.initState();
    isSettledStates = widget.expense.isSettled;
    fetchMyGroupPaymentsDetail();
    checkIfEditable();
  }

  void checkIfEditable() async {
    bool canEdit = await getMoneyRequestIsEdit(widget.groupId, widget.expense.transactionId);
    setState(() {
      isEditable = !canEdit;
    });
  }

  void fetchMyGroupPaymentsDetail() async {
    final MyGroupPaymentsDetailJson = await getMyGroupPaymentsDetail(widget.groupId, widget.expense.transactionId);
    print('---------------------------정산디테일의 데이터 받아오는중');
    if (MyGroupPaymentsDetailJson != null) {
      setState(() {
        request = RequestDetail.fromJson(MyGroupPaymentsDetailJson.data);
        amounts = request.members.map((member) => member.amount).toList();
        remainderAmount = request.remainder;
        isLockedList = request.members.map((member) => member.lock).toList();
        print(request.toString());
        print('-------------------------------------------');
      });
    } else {
      print("정산 데이터를 불러오는 데 실패했습니다.");
    }
  }

  void updateIsSettledStates(bool newStates) {
    setState(() {
      isSettledStates = newStates;
      widget.onSuccess(isSettledStates);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        await Future.delayed(Duration.zero);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => GroupItem(groupId: widget.groupId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = Offset(-1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.expense.transactionSummary),
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.pop(context);
              await Future.delayed(Duration.zero);
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => GroupItem(groupId: widget.groupId),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    var begin = Offset(-1.0, 0.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 300),
                ),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MoneyRequestItem(
                expense: widget.expense,
                isToggle: false,
                groupId: widget.groupId,
                clickable: false,
              ),
              if (request.members.isNotEmpty) ...[
                SizedBox(
                  width: 343.w,
                  child: Row(
                    children: [
                      Text('${request.memo}'),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5.w)),
                widget.expense.receiptEnrolled
                    ? SizedButton(
                        btnText: '상세항목 보기',
                        size: ButtonSize.l,
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReceiptView(expense: widget.expense, groupId: widget.groupId, expenseDetail: request, isSplit: true)),
                          );
                          if (result == true) {
                            fetchMyGroupPaymentsDetail();
                          }
                        })
                    : SizedBox(),
                SizedBox(
                  height: 30.h,
                ),
                Expanded(
                  child: SizedBox(
                    //width: 368.w,
                    height: 400.h,
                    child: RequestMemberList(
                      requestDetail: request,
                      amountList: amounts,
                      allSettledCallback: updateIsSettledStates,
                      callbackAmountList: (List<int> value) {
                        //amounts = value;
                        setState(() {
                          amounts = value;
                          amounts = reCalculateAmount(widget.expense.transactionBalance, amounts, isLockedList);
                          remainderAmount = reCalculateRemainder(widget.expense.transactionBalance, amounts);
                          sendPutRequest();
                        });
                      },
                      isLockList: (List<bool> value) {
                        isLockedList = value;
                      },
                      isSplit: true,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10.w)),
                MoneyRequestDetailBottom(
                  amount: remainderAmount,
                ),
              ] else ...[
                Expanded(
                  child: Center(
                    child: Lottie.asset('assets/lotties/orangewalking.json'),
                  ),
                ),
              ],
              Padding(padding: EdgeInsets.symmetric(vertical: 10.w)),
            ],
          ),
        ),
      ),
    );
  }

  void sendPutRequest() {
    List<RequestMember> newMembers = List<RequestMember>.generate(request.members.length, (index) {
      return RequestMember(
        memberId: request.members[index].memberId,
        profileUrl: request.members[index].profileUrl,
        name: request.members[index].name,
        amount: amounts[index],
        lock: isLockedList[index],
      );
    });
    RequestDetailModifyRequest newRequestDetail = RequestDetailModifyRequest(memo: widget.expense.memo ?? '', memberList: newMembers);

    putPaymentsMembers(widget.groupId, widget.expense.transactionId, newRequestDetail.toJson());
  }

  Future<void> navigateToMoneyRequestModify() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoneyRequestModify(
          expense: widget.expense,
          groupId: widget.groupId,
        ),
      ),
    );

    if (result == true) {
      fetchMyGroupPaymentsDetail();
      checkIfEditable();
    }
  }
}
