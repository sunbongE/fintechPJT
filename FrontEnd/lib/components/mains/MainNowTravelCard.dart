import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../entities/Group.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MainNowTravelCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const MainNowTravelCard({Key? key, required this.group, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: 200.w,
        height: 30.h,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // child: Container(
          //   child: Text(group.groupName),
          // ),
          child: ListTile(
            onTap: onTap,
            title: Text(
              group.groupName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
              ),
            ),
            subtitle: Container(
              height: 120.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.theme),
                  Text('시작일: ${group.startDate}'),
                  Text('종료일: ${group.endDate}'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
