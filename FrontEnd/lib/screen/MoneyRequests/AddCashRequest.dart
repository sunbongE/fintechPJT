import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/moneyrequests/AmountInputField.dart';
import 'package:front/components/moneyrequests/MoneyRequestList.dart';
import 'package:front/components/moneyrequests/RequestMemberList.dart';
import 'package:lottie/lottie.dart';

import '../../components/moneyrequests/AddCashAmountInputField.dart';
import '../../components/moneyrequests/AddCashTextInputField.dart';
import '../../entities/RequestCash.dart';
import '../../entities/RequestMember.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../models/button/SizedButton.dart';
import '../../repository/api/ApiGroup.dart';

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
      requestCash.transactionBalance = int.tryParse(_priceController.text) ?? 0;
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
    return _titleController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _priceController.text.isNotEmpty;
  }
  void fetchMyGroupMemberList() async {
    final MyGroupMemberListJson = await getGroupMemberList(widget.groupId);
    final members = List<RequestMember>.from(MyGroupMemberListJson.data['groupMembersDtos'].map((x) => RequestMember.fromCashJson(x)));
    String currentDate = DateTime.now().toString().split(' ')[0]; // YYYY-MM-DD 형식
    String currentTime = DateTime.now().toString().split(' ')[1]; // 시간
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
      });
    } else {
      print("그룹 데이터를 불러오는 데 실패했습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () => Navigator.pop(context),
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
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: '장소',
                hintText: '장소를 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            AmountInputField(
              controller: _priceController,
              onSubmitted: (String ) {  },
            ),
          if (requestCash.members?.isNotEmpty ?? false) ...[
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                height: 400.h,
                child: RequestMemberList(
                    requestDetail: requestCash,
                    allSettledCallback: (bool value){},
                    callbackAmountList: (List<int> value){},
                    amountList: amountList,
                    isLockList: (List<bool> value){}),
              ),
            ),
          ] else
            ...[
              Flexible (
            fit: FlexFit.loose,
                child: Center(
                  child: Lottie.asset('assets/lotties/orangewalking.json'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
