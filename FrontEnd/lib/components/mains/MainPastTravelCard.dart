import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../entities/Group.dart';

class MainPastTravelCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const MainPastTravelCard({Key? key, required this.group, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.w,
      height: 30.h,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            onTap: onTap,

            title: Container(
              height: 130.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                // image: Decoration Image(
                //   image: NetworkImage(group.image),
                //   fit: BoxFit.cover, // 이미지를 커버 모드로 설정
                // ),
              ),
              child: Padding(

                padding: EdgeInsets.all(5.0.w),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(), // 이미지 위에 텍스트가 오도록 공간 확보
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group.theme.length > 5 ? '${group.theme.substring(0, 4)}..' : group.groupName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30.sp,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 20.w,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8.w), // 아이콘과 텍스트 사이의 간격 추가
                                  Expanded(
                                    child: Text(
                                      '${group.startDate} - ${group.endDate}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(width: 20.w),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
