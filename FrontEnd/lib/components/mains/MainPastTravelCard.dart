import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/MyTripHistoryDetail.dart';
import '../../entities/Group.dart';

class MainPastTravelCard extends StatelessWidget {
  final Group group;
  final String imagePath;

  const MainPastTravelCard(
      {Key? key, required this.group, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void navigateToGroupDetail(Group group) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyTripHistoryDetail(groupData: group)),
      );
    }

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: 230.w,
            height: 130.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              image: DecorationImage(
                image: AssetImage(imagePath), // AssetImage를 사용하여 로컬 이미지 로드
                fit: BoxFit.cover,
              ),
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
                              group.theme.length > 4
                                  ? '${group.theme.substring(0, 3)}..'
                                  : group.groupName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.sp,
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
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                          onPressed: () => navigateToGroupDetail(group),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
