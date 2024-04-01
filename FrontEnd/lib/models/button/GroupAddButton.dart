import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';

class GroupAddButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const GroupAddButton({
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<GroupAddButton> createState() => _ButtonState();
}

class _ButtonState extends State<GroupAddButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: 170.w,
          height: 140.h,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '여행 그룹 만들기',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: widget.onPressed,
                    style: ElevatedButton.styleFrom(
      
                      backgroundColor: ADDBUTTON,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 버튼의 모서리를 둥글게
                      ),
                      fixedSize: Size(50.w, 50.h),
                    ),
                    child: Text(
                        '+',
                      style: TextStyle(
                      fontSize: 40.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
      
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
