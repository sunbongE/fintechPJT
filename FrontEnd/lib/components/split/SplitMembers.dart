import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

import '../../entities/SplitDoingResponse.dart';
import '../../providers/store.dart';

class SplitMembers extends StatefulWidget {
  final groupId;
  final SplitDoingResponse member;
  const SplitMembers({super.key, this.groupId, required this.member});

  @override
  State<SplitMembers> createState() => _SplitMembersState();
}

class _SplitMembersState extends State<SplitMembers> {
  var userManager = UserManager();

  @override
  Widget build(BuildContext context) {
    userManager.loadUserInfo();

    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          width: 60.w,
          height: 60.h,
          child: Image.network('${widget.member.thumbnailImage}', fit: BoxFit.cover),
        ),
      ),
      title: Text(
        "${widget.member.name}",
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: widget.member.isReady ? Text("정산완료") : Text("정산 미진행"),
      trailing: widget.member.isReady ? Icon(Icons.check_box, color: PRIMARY_COLOR) : Icon(Icons.check_box_outline_blank, color: PRIMARY_COLOR),
    );
  }
}
