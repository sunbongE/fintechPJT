import 'package:flutter/material.dart';
import 'package:front/screen/groupscreens/GroupModify.dart';
import '../../entities/Group.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupDescription extends StatefulWidget {
  final Group group;
  final VoidCallback onEdit;

  const GroupDescription({Key? key, required this.group, required this.onEdit})
      : super(key: key);

  @override
  _GroupDescriptionState createState() => _GroupDescriptionState();
}
class _GroupDescriptionState extends State<GroupDescription> {
  @override

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.group.description,
                style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${widget.group.startDate} ~ ${widget.group.endDate}',
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async { // 비동기 함수로 변경
            final modifiedGroup = await Navigator.push<Group>(
              context,
              MaterialPageRoute(builder: (context) => GroupModify(group: widget.group)),
            );

            if (modifiedGroup != null) {
              widget.onEdit(); // 수정된 그룹을 처리하는 로직을 여기에 추가하거나, 콜백을 호출
            }
          },
        ),


      ],
    );
  }
}
