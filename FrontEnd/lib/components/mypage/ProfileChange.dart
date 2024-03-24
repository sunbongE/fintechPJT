import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/button/ButtonSlideAnimation.dart';
import '../../providers/store.dart';
import '../../repository/api/ApiMyPage.dart';
import 'LogoutModal.dart';
import 'ProfileChangeBtn.dart';

class ProfileChange extends StatefulWidget {
  final Function onUpdate;

  const ProfileChange({super.key, required this.onUpdate});

  @override
  State<ProfileChange> createState() => _ProfileChangeState();
}

class _ProfileChangeState extends State<ProfileChange> {
  var userManager = UserManager();
  File? _image;

  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future uploadImage(File image) async {
    if (image == null) return;
    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path, filename: fileName),
    });
    final res = await putUploadImage(formData);
    print(res.data);

    UserManager userManager = UserManager();
    await userManager.saveUserInfo(
      newThumbnailImageUrl: res.data['thumbnailImagePathURL'],
      newProfileImageUrl: res.data['profileImagePath'],
    );
    buttonSlideAnimationPushAndRemoveUntil(context, 3);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
                      ClipOval(
                        child: _image == null
                            ? Image.network(
                                "${userManager.thumbnailImageUrl}",
                                width: 100.w,
                                height: 100.w,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                _image!,
                                width: 100.w,
                                height: 100.w,
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
            SizedBox(
              height: 30.h,
            ),
            ProfileChangeBtn(
              buttonText: '저장',
              onPressed: () {
                if (_image != null) {
                  uploadImage(_image!);
                }
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
