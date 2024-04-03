import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/StateContainer.dart';
import 'package:front/components/groups/isDoneContainer.dart';
import '../../const/colors/Colors.dart';
import '../../entities/Group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupCard({Key? key, required this.group, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime endDateParsed = DateTime.parse(group.endDate);
    bool groupNow = today.isAfter(endDateParsed);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: BG_COLOR.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: BG_COLOR, width: 2.w),
        ),
        // height: 100.h,
        child: ListTile(
          onTap: onTap,
          title: Row(
            children: [
              Text(
                group.startDate,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 8.sp,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                '~',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 8.sp,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                group.endDate,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 8.sp,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.groupName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          trailing: group.isCalculateDone ? isDoneContainer(groupState: groupNow) : StateContainer(groupState: groupNow),
        ),
      ),
    );
  }
}
