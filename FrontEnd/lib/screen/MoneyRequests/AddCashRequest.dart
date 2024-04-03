import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/AmountInputField.dart';
import 'package:front/components/moneyrequests/MoneyRequestList.dart';
import 'package:front/components/moneyrequests/RequestMemberList.dart';
import 'package:lottie/lottie.dart';

import '../../components/addreceipt/SelectLocation.dart';
import '../../components/moneyrequests/AddCashAmountInputField.dart';
import '../../components/moneyrequests/AddCashTextInputField.dart';
import '../../components/moneyrequests/MoneyRequestDetailBottom.dart';
import '../../entities/RequestCash.dart';
import '../../entities/RequestMember.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../models/button/SizedButton.dart';
import '../../repository/api/ApiGroup.dart';
import '../../repository/api/ApiMoneyRequest.dart';
import '../../utils/RequestModifyUtil.dart';
import '../MoneyRequest.dart';

class AddCashRequest extends StatefulWidget {
  final int groupId;

  const AddCashRequest({Key? key, required this.groupId}) : super(key: key);

  @override
  _AddCashRequestState createState() => _AddCashRequestState();
}

class _AddCashRequestState extends State<AddCashRequest> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  RequestCash requestCash = RequestCash.empty();
  int remainderAmount = 0;
  List<int> amountList = [];
  late List<bool> isLockList;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateState);
    _locationController.addListener(_updateState);
    _priceController.addListener(_updateState);
    fetchMyGroupMemberList();
  }

  void _updateState() {
    setState(() {
      requestCash.transactionBalance = int.tryParse(_priceController.text.replaceAll(',', '')) ?? 0;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  bool _isFormFilled() {
    return _titleController.text.isNotEmpty && _locationController.text.isNotEmpty && _priceController.text.isNotEmpty;
  }

  void fetchMyGroupMemberList() async {
    final MyGroupMemberListJson = await getGroupMemberList(widget.groupId);
    final members = List<RequestMember>.from(MyGroupMemberListJson.data['groupMembersDtos'].map((x) => RequestMember.fromCashJson(x)));
    String currentDate = DateTime.now().toString().split(' ')[0]; // YYYY-MM-DD 형식
    String currentTime = DateTime.now().toString().split(' ')[1].split('.')[0]; // 시간
    int exampleRemainder = 0;
    if (MyGroupMemberListJson != null) {
      setState(() {
        requestCash = RequestCash(
          transactionSummary: _titleController.text,
          location: _locationController.text,
          transactionBalance: int.tryParse(_priceController.text) ?? 0,
          transactionDate: currentDate,
          transactionTime: currentTime,
          members: members,
          remainder: exampleRemainder,
        );
        amountList = List<int>.filled(members.length, 0);
        isLockList = List<bool>.filled(members.length, false);
      });
    } else {
      print("그룹 데이터를 불러오는 데 실패했습니다.");
    }
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
            pageBuilder: (context, animation, secondaryAnimation) => MoneyRequest(groupId: widget.groupId),
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
          title: Text('현금계산 항목 추가'),
          scrolledUnderElevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedButton(
                btnText: '완료',
                size: ButtonSize.xs,
                borderRadius: 10,
                onPressed: _isFormFilled()
                    ? () async {
                        final groupId = widget.groupId;

                        List<RequestMember> newMembers = List<RequestMember>.generate(requestCash.members.length, (index) {
                          return RequestMember(
                            memberId: requestCash.members[index].memberId,
                            profileUrl: requestCash.members[index].profileUrl,
                            name: requestCash.members[index].name,
                            amount: amountList[index],
                            lock: isLockList[index],
                          );
                        });

                        RequestCash newRequestCash = RequestCash(
                            transactionSummary: _titleController.text,
                            location: _locationController.text,
                            transactionBalance: int.tryParse(_priceController.text.replaceAll(',', '')) ?? 0,
                            transactionDate: requestCash.transactionDate,
                            transactionTime: requestCash.transactionTime,
                            members: newMembers,
                            remainder: remainderAmount);

                        final data = newRequestCash.toJson();

                        try {
                          final response = await postAddCash(groupId, data);
                          print('현금 등록 post 요청 성공: $response');
                          Navigator.pop(context, true);
                        } catch (e) {
                          print('오류: $e');
                        }
                      }
                    : null,
                enable: _isFormFilled(),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '제목',
                  hintText: '제목을 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // 지도에서 마커로 가져와서 장소 value 입력하게 해둠~~
              // 근데.. 밑에 가격입력하는 창이 너무 눈에 안띔.. 일단 난 못찾았었어. 처음에 . 코드보고 알았음..
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: '장소',
                        hintText: '장소를 입력하세요',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.map),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SelectLocation(),
                              ),
                            );
                            if (result is String) {
                              _locationController.text = result;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              AddCashAmountInputField(
                controller: _priceController,
                onSubmitted: (String) {}, labelText: '가격', hintText: 'ex)10000',
              ),
              if (requestCash.members?.isNotEmpty ?? false) ...[
                Flexible(
                  fit: FlexFit.loose,
                  child: SizedBox(
                    height: 400.h,
                    child: RequestMemberList(
                        requestDetail: requestCash,
                        allSettledCallback: (bool value) {},
                        callbackAmountList: (List<int> value) {
                          setState(() {
                            amountList = value;
                            amountList = reCalculateAmount(requestCash.transactionBalance, amountList, isLockList);
                            print(amountList);
                            remainderAmount = reCalculateRemainder(requestCash.transactionBalance, amountList);
                            print(remainderAmount);
                          });
                        },
                        amountList: amountList,
                        isLockList: (List<bool> value) {}),
                  ),
                ),
                MoneyRequestDetailBottom(
                  amount: remainderAmount,
                ),
              ] else ...[
                Flexible(
                  fit: FlexFit.loose,
                  child: Center(
                    child: Lottie.asset('assets/lotties/orangewalking.json'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
