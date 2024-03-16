import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/button/Button.dart';

class IntroBox extends StatefulWidget {
  final String title;
  final String desc;
  final VoidCallback onNext;

  const IntroBox({
    required this.title,
    required this.desc,
    required this.onNext,
    Key? key,
  }) : super(key: key);

  @override
  State<IntroBox> createState() => _IntroBoxState();
}

class _IntroBoxState extends State<IntroBox> {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 350.w,
      height: 350.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.title,
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 22.h,
                ),
                Text(widget.desc, style: TextStyle(fontSize: 16.sp)),
              ],
            ),
          ),
          Button(
            btnText: "Next",
            onPressed: widget.onNext,
          ),
        ],
      ),
    );
  }
}
