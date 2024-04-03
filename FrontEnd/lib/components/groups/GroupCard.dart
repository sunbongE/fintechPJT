import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/StateContainer.dart';
import 'package:front/components/groups/isDoneContainer.dart';
import '../../entities/Group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupCard({Key? key, required this.group, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime endDateParsed = DateTime.parse(group.endDate);
    bool groupNow = today.isAfter(endDateParsed);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: groupNow
            ? Color(0xffFF3D00).withOpacity(0.5)
            : Color(0xffFF9E44).withOpacity(0.8),
        child: ListTile(
          onTap: onTap,
          title: Row(
            children: [
              Text(
                group.startDate,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.sp,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                '~',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8.sp,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Text(
                group.endDate,
                style: TextStyle(
                  color: Colors.white,
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
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          trailing: group.isCalculateDone
            ? isDoneContainer(groupState: groupNow)
          : StateContainer(groupState: groupNow),
        ),
      ),
    );
  }
}
