import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

class BankList extends StatefulWidget {
  final Function(String) onBankSelected;

  const BankList({Key? key, required this.onBankSelected}) : super(key: key);

  @override
  State<BankList> createState() => _BankListState();
}

class Bank {
  final String name;
  final String code;

  Bank({required this.name, required this.code});
}

class _BankListState extends State<BankList> {
  final List<Bank> bankList = [
    Bank(name: '경남은행', code: '01'),
    Bank(name: '광주은행', code: '02'),
    Bank(name: '국민은행', code: '03'),
    Bank(name: '농협은행주식회사', code: '04'),
    Bank(name: '대구은행', code: '05'),
    Bank(name: '부산은행', code: '06'),
    Bank(name: '수협은행', code: '07'),
    Bank(name: '신한은행', code: '08'),
    Bank(name: '우리은행', code: '09'),
    Bank(name: '전북은행', code: '10'),
    Bank(name: '제주은행', code: '11'),
    Bank(name: '주식회사 카카오뱅크', code: '12'),
    Bank(name: '주식회사 케이뱅크', code: '13'),
    Bank(name: '중소기업은행', code: '14'),
    Bank(name: '토스뱅크 주식회사', code: '15'),
    Bank(name: '하나은행', code: '16'),
    Bank(name: '한국산업은행', code: '17'),
    Bank(name: '한국스탠다드차타드은행', code: '18'),
    Bank(name: '한국은행', code: '19'),
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
                          // 선택한 은행 한번 더 누르면 지워지기
                          if (selectedBankIndex == index) {
                            selectedBankIndex = null;
                            widget.onBankSelected('');
                          } else {
                            selectedBankIndex = index;
                            widget.onBankSelected(bankList[index].name);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedBankIndex == index
                              ? PRIMARY_COLOR.withOpacity(0.5)
                              : Colors.grey[200],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/images/banks/${bankList[index].name}.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              bankList[index].name,
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
