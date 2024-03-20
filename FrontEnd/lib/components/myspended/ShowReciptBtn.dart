import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';

import '../../const/colors/Colors.dart';

class ShowReciptBtn extends StatelessWidget {
  const ShowReciptBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      '메롱',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Text(
            '영수증 보기',
            style: TextStyle(
                color: TEXT_COLOR,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
