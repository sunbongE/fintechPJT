import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${userManager.name}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                      letterSpacing: 3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (userManager.email != null) {
                        Clipboard.setData(ClipboardData(text: userManager.email!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('클립보드에 복사되었습니다')),
                        );
                      }
                    },
                    child: Text(
                      "${userManager.email}",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Color(0xff6E6E6E),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
