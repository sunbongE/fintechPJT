import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/models/CustomDivider.dart';
import 'package:intl/intl.dart';
import '../../const/colors/Colors.dart';
import '../../entities/SplitDoneResponse.dart';
import '../../providers/store.dart';

class SplitResult extends StatefulWidget {
  final SplitDoneResponse splitResult;

  const SplitResult({super.key, required this.splitResult});

  @override
  State<SplitResult> createState() => _SplitResultState();
}

class _SplitResultState extends State<SplitResult> {
  var userManager = UserManager();

  @override
  Widget build(BuildContext context) {
    userManager.loadUserInfo();
    // String amountText = '0원';
    // Color amountColor = Colors.black;
    // String titleText = '';
    // String subtitleText = '';
    // String imageUrl = '';

    // receiveName
    // receiveImage
    // sendName
    // sendImage
    // amount
    //

    //
    // if (widget.splitResult.receiveName == userManager.name) {
    //   amountText = '+${NumberFormat('#,###').format(widget.splitResult.amount)}원';
    //   amountColor = Colors.green;
    //   titleText = '${widget.splitResult.sendName}님께';
    //   subtitleText = '받은 금액';
    //   imageUrl = widget.splitResult.sendImage;
    // } else if (widget.splitResult.sendName == userManager.name) {
    //   amountText = '-${NumberFormat('#,###').format(widget.splitResult.amount)}원';
    //   amountColor = Color(0xffFF5252);
    //   titleText = '${widget.splitResult.receiveName}님께';
    //   subtitleText = '보낸 금액';
    //   imageUrl = widget.splitResult.receiveImage;
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //보내는 부분
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(100.w),
                              child: SizedBox(
                                  width: 60.w,
                                  height: 60.h,
                                  child: Image.network(
                                      widget.splitResult.sendImage,
                                      fit: BoxFit.cover))),
                          SizedBox(width: 25.w),
                          Text(widget.splitResult.sendName,
                              style: TextStyle(fontSize: 13.sp)),
                          // Text(subtitleText, style: TextStyle(fontSize: 16.sp)),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Icon(Icons.arrow_right),
                              // Icon(Icons.arrow_right),
                              Text(
                                  '${NumberFormat('#,###').format(widget.splitResult.amount)}원',
                                  style: TextStyle(fontSize: 20.sp)),
                              // Icon(Icons.arrow_right),
                              // Icon(Icons.arrow_right),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                              child: SizedBox(
                                  width: 60.w,
                                  height: 60.h,
                                  child: Image.network(
                                      widget.splitResult.receiveImage,
                                      fit: BoxFit.cover))),
                          SizedBox(width: 25.w),
                          Text(widget.splitResult.receiveName,
                              style: TextStyle(fontSize: 13.sp)),
                          // Text(subtitleText, style: TextStyle(fontSize: 16.sp)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Text(amountText, style: TextStyle(fontSize: 18.sp, color: amountColor)),
              ],
            ),
          ),
        ),
        CustomDivider(),
      ],
    );
    // return ListTile(
    //   leading: ClipOval(
    //     child: SizedBox(
    //       width: 60.w,
    //       height: 60.h,
    //       child: Image.network(imageUrl, fit: BoxFit.cover),
    //     ),
    //   ),
    //   title: Text(
    //     titleText,
    //     style: TextStyle(
    //       fontSize: 20.sp,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    //   subtitle: Text(
    //     subtitleText,
    //     style: TextStyle(
    //       fontSize: 16.sp,
    //     ),
    //   ),
    //   trailing: Text(
    //     amountText,
    //     style: TextStyle(
    //       color: amountColor,
    //       fontSize: 18.sp,
    //     ),
    //   ),
    // );
  }
}

// [
// {
// receiveKakaoId: 3386029769,
// receiveName: 김민준,
// receiveImage: https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R110x110,
// sendKakaoId: 3389826401,
// sendName: 전승혜,
// sendImage: https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R110x110,
// amount: 16175
// }, {
// receiveKakaoId: 3386029769,
// receiveName: 김민준,
// receiveImage: https://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R110x110,
// sendKakaoId: 3394990331,
// sendName: 김지연,
// sendImage: https://k.kakaocdn.net/dn/yUVv6/btsE0hgI67b/xdJ5ax58CQoCAmkvnHZaN1/img_110x110.jpg,
// amount: 1175}
// ]
