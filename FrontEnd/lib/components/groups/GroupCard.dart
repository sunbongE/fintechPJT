import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/groups/StateContainer.dart';
import 'package:front/const/colors/Colors.dart';
import '../../entities/Group.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback onTap;

  const GroupCard({Key? key, required this.group, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime endDateParsed = DateTime.parse(group.endDate);
    bool groupState = today.isAfter(endDateParsed);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: groupState ? COMPLETE_COLOR : TRAVELING,
        child: ListTile(
          onTap: onTap,
          title: Text(
            group.groupName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group.theme),
              Text('시작일: ${group.startDate}'),
              Text('종료일: ${group.endDate}'),
            ],
          ),
          trailing: StateContainer(groupState: groupState),
        ),
      ),
    );
  }
}
