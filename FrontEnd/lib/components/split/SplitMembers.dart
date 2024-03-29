import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

import '../../providers/store.dart';

class SplitMembers extends StatefulWidget {
  final groupId;
  const SplitMembers({super.key, this.groupId});

  @override
  State<SplitMembers> createState() => _SplitMembersState();
}

class _SplitMembersState extends State<SplitMembers> {
  var userManager = UserManager();
  bool isReady = true;

  @override
  Widget build(BuildContext context) {
    userManager.loadUserInfo();

    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          width: 60.w,
          height: 60.h,
          child: Image.network('${userManager.thumbnailImageUrl}', fit: BoxFit.cover),
        ),
      ),
      title: Text(
        "${userManager.name}",
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: isReady ? Text("{2024-03-08} 정산완료") : Text("정산 미진행"),
      trailing: isReady ? Icon(Icons.check_box, color: PRIMARY_COLOR) : Icon(Icons.check_box_outline_blank, color: PRIMARY_COLOR),
    );
  }
}
