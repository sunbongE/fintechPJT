import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

class BankList extends StatefulWidget {
  final Function(Map<String, String>) onBankSelected;

  const BankList({Key? key, required this.onBankSelected}) : super(key: key);

  @override
  State<BankList> createState() => _BankListState();
}

class _BankListState extends State<BankList> {
  final List<Map<String, String>> bankList = [
    {'name': '한국은행', 'code': '001'},
    {'name': '광주은행', 'code': '002'},
    {'name': '농협은행주식회사', 'code': '003'},
    {'name': '대구은행', 'code': '004'},
    {'name': '부산은행', 'code': '005'},
    {'name': '수협은행', 'code': '006'},
    {'name': '신한은행', 'code': '007'},
    {'name': '우리은행', 'code': '008'},
    {'name': '전북은행', 'code': '009'},
    {'name': '주식회사 카카오뱅크', 'code': '010'},
    {'name': '주식회사 케이뱅크', 'code': '011'},
    {'name': '중소기업은행', 'code': '012'},
    {'name': '토스뱅크 주식회사', 'code': '013'},
    {'name': '하나은행', 'code': '014'},
    {'name': '한국산업은행', 'code': '015'},
    {'name': '한국스탠다드차타드은행', 'code': '016'},
    {'name': '경남은행', 'code': '017'},
    {'name': '국민은행', 'code': '018'},
    {'name': '제주은행', 'code': '019'},
  ];

  int? selectedBankIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 117.w / 95.h,
                  ),
                  itemCount: bankList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedBankIndex == index) {
                            selectedBankIndex = null;
                            widget.onBankSelected({});
                          } else {
                            selectedBankIndex = index;
                            widget.onBankSelected(bankList[index]);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedBankIndex == index ? PRIMARY_COLOR.withOpacity(0.5) : Colors.grey[200],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/images/banks/${bankList[index]['name']}.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              '${bankList[index]['name']}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
