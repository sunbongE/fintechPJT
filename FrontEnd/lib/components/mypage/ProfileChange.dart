import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/components/mypage/LogoutModal.dart';
import 'package:front/components/mypage/ProfileChangeBtn.dart';
import 'package:image_picker/image_picker.dart';
import '../../const/colors/Colors.dart';
import '../../providers/store.dart';
import '../../repository/api/ApiMyPage.dart';

class ProfileChange extends StatefulWidget {
  const ProfileChange({super.key});

  @override
  State<ProfileChange> createState() => _ProfileChangeState();
}

class _ProfileChangeState extends State<ProfileChange> {
  var userManager = UserManager();
  File? _image;

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        print(_image);
        // '/data/user/0/com.example.front/cache/81e68eaa-0814-41eb-bf14-d6dff0fda1a5/profileChange.png'
      });
      uploadImage(_image);
    }
  }

  Future uploadImage(File? image) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "프로필 수정",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: getImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _image == null
                            ? Image.network(
                                "${userManager.thumbnailImageUrl}",
                                width: 100.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                _image!,
                                width: 100.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Image.asset(
                        "assets/images/profileModify.png",
                        width: 30.w,
                        height: 30.h,
                      ),
                    ],
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
            SizedBox(height: 30.h,),
            ProfileChangeBtn(
              buttonText: '저장',
              onPressed: () {
                // putProfileImage(_image);
                // UserManager().saveUserInfo(newThumbnailImageUrl: _image.toString());
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            Spacer(),
            TextButton(
              onPressed: () => LogoutModal(context),
              child: Text(
                "로그아웃",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
