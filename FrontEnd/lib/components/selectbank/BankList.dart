import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

class BankList extends StatefulWidget {
  final Function(String) onBankSelected;

  const BankList({Key? key, required this.onBankSelected}) : super(key: key);

  @override
  State<BankList> createState() => _BankListState();
}

class _BankListState extends State<BankList> {
  final List<String> bankList = [
    '경남은행',
    '광주은행',
    '국민은행',
    '농협은행주식회사',
    '대구은행',
    '부산은행',
    '수협은행',
    '신한은행',
    '우리은행',
    '전북은행',
    '제주은행',
    '주식회사 카카오뱅크',
    '주식회사 케이뱅크',
    '중소기업은행',
    '토스뱅크 주식회사',
    '하나은행',
    '한국산업은행',
    '한국스탠다드차타드은행',
    '한국은행',
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
                            widget.onBankSelected('');
                          } else {
                            selectedBankIndex = index;
                            widget.onBankSelected(bankList[index]);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedBankIndex == index
                              ? PRIMARY_COLOR
                              : Colors.grey[200],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/images/banks/${bankList[index]}.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(bankList[index]),
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
