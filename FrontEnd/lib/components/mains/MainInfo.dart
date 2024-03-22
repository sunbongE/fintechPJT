import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/store.dart';

class MyInfoMain extends StatefulWidget {
  const MyInfoMain({super.key});

  @override
  State<MyInfoMain> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfoMain> {
  late Future userInfoFuture;
  var userManager = UserManager();

  @override
  void initState() {
    super.initState();
    userManager.loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "${userManager.thumbnailImageUrl}",
                  width: 75.w,
                  height: 75.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 21.w,
              ),
              Text(
                "${userManager.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
