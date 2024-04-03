import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../entities/Group.dart';
import 'package:front/const/colors/Colors.dart';

class MainNowTravelCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;
  final bool isCenter;

  const MainNowTravelCard({
    Key? key,
    required this.group,
    required this.onTap,
    required this.isCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = isCenter ? 15.sp : 10.sp;
    double themeSize = isCenter ? 20.sp : 15.sp;
    double subFontSize = isCenter ? 10.sp : 6.sp;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Container(
          width: 230.w,
          height: 130.h,
          child: Padding(
            padding: EdgeInsets.all(10), // 원하는 패딩 크기로 조절 가능
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_circle_right_rounded,
                          color: BUTTON_COLOR,
                        ),
                        Text(
                          group.groupName.length > 5
                              ? '${group.groupName.substring(0, 4)}..'
                              : group.groupName,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      group.theme.length > 4
                          ? '${group.theme.substring(0, 4)}..'
                          : group.theme,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: themeSize,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        group.startDate,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: subFontSize,
                        ),
                      ),
                      Text(
                        '~',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: subFontSize,
                        ),
                      ),
                      Text(
                        group.endDate,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: subFontSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
