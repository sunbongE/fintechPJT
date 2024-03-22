import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../const/colors/Colors.dart';
import '../../repository/api/ApiReceipt.dart';

class AddReceipt extends StatefulWidget {
  const AddReceipt({super.key});

  @override
  State<AddReceipt> createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {
  final ImagePicker picker = ImagePicker();

  void receiptfromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      String fileName = image.name;
      String requestId = DateTime.now().millisecondsSinceEpoch.toString();
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path, filename: fileName),
        'message': jsonEncode({
          "version": "V2",
          "requestId": requestId,
          "timestamp": 0,
          "images": [
            {
              "format": "jpg",
              "name": fileName,
            }
          ]
        }),
      });
      final res = await postReceiptImage(formData);
      print("Response data: ${res?.data}");
    }
  }

  // 10장으로 max걸기
  void receiptfromGallary() async {
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null && images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        var image = images[i];
        String fileName = image.name;
        FormData formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(image.path, filename: fileName),
          'message': jsonEncode({
            "version": "V2",
            "requestId": i.toString(),
            "timestamp": DateTime.now().millisecondsSinceEpoch,
            "images": [
              {
                "format": "jpg",
                "name": fileName,
              }
            ]
          }),
        });
        final res = await postReceiptImage(formData);
        print("Response data: ${res?.data}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("영수증 등록"),
        ),
        body: buildReceiptPage("영수증은 한번에\n최대 10장까지 등록 가능합니다."));
  }

  @override
  Widget buildReceiptPage(String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EasyRichText(
          title,
          defaultStyle: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            height: 2.5.h,
            letterSpacing: 1.0.w,
          ),
          patternList: [
            EasyRichTextPattern(
              targetString: "최대 10장",
              style: TextStyle(color: TEXT_COLOR),
            ),
          ],
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: receiptfromCamera,
              child: Column(
                children: [
                  Icon(CupertinoIcons.camera_fill),
                  Text("사진 찍기"),
                ],
              ),
            ),
            GestureDetector(
              onTap: receiptfromGallary,
              child: Column(
                children: [
                  Icon(CupertinoIcons.photo),
                  Text("갤러리에서 가져오기"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
