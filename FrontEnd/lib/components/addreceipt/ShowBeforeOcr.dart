import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/FlutterToastMsg.dart';
import 'package:front/models/button/ButtonSlideAnimation.dart';
import 'package:image_picker/image_picker.dart';
import '../../entities/Receipt.dart';
import '../../models/button/SizedButton.dart';
import '../../repository/api/ApiReceipt.dart';
import '../../screen/YjReceipt.dart';
import 'ModifyReceipt.dart';

class ShowBeforeOcr extends StatefulWidget {
  ShowBeforeOcr({Key? key}) : super(key: key);

  @override
  State<ShowBeforeOcr> createState() => _ShowBeforeOcrState();
}

class _ShowBeforeOcrState extends State<ShowBeforeOcr> {
  List<Receipt> receiptData = [];

  final PageController _pageController = PageController();
  final ImagePicker picker = ImagePicker();

  double _progressValue = 0;
  bool isEditing = false;

  @override
  void dispose() {
    super.dispose();
  }

  // 영수증 수정페이지로 이동 후 콜백 및 수정 사항 적용
  void _navigateAndEditReceipt(BuildContext context, int index) async {
    final modifiedReceipt = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ModifyReceipt(receipt: receiptData[index]),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(Tween(begin: Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease))),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );

    if (modifiedReceipt != null) {
      setState(() {
        receiptData[index] = modifiedReceipt;
      });
    }
  }

  // 하단 모달
  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('사진 찍기'),
                    onTap: () {
                      Navigator.pop(context);
                      receiptFromCamera();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('갤러리에서 가져오기'),
                  onTap: () {
                    Navigator.pop(context);
                    receiptFromGallery();
                  },
                ),
              ],
            ),
          );
        });
  }

  // 카메라로 사진찍기
  void receiptFromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      onImageSelected(image);
    }
  }

  // 갤러리에서 사진 가져오기
  void receiptFromGallery() async {
    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      if (selectedImages.length > 10) {
        FlutterToastMsg('한 번에 최대 10장까지만 선택할 수 있습니다.');
        return;
      }

      for (XFile image in selectedImages) {
        await onImageSelected(image);
      }
    }
  }

  // 선택된 이미지를 네이버 클로바로 보내는 api 호출
  Future<void> onImageSelected(XFile image) async {
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
    Receipt receipt = Receipt.fromJson(res.data);

    debugPrint("2222222222 data: ${receipt.storeName}");
    debugPrint("3333333333 data: ${receipt.subName}");
    debugPrint("4444444444 data: ${receipt.addresses}");
    debugPrint("5555555555 data: ${receipt.date}");
    debugPrint("6666666666 data: ${receipt.items}");
    debugPrint("7777777777 data: ${receipt.totalPrice}");

    setState(() {
      receiptData.add(receipt);
    });
  }

  // 영수증이 없을 때의 페이지
  Widget _buildAddReceiptPage() {
    return Center(
      child: TextButton(
        onPressed: () => showModal(),
        child: Icon(
          Icons.add,
          color: PRIMARY_COLOR,
          size: 50.0.sp,
        ),
        style: TextButton.styleFrom(
          backgroundColor: BG_COLOR,
          shape: CircleBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _progressValue,
            backgroundColor: BG_COLOR,
            valueColor: AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
          ),
          Expanded(
            child: Center(
              child: receiptData.isEmpty
                  ? _buildAddReceiptPage()
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: receiptData.length + 1,
                      onPageChanged: (int index) {
                        setState(() {
                          _progressValue = index + 1 / (receiptData.length + 1);
                        });
                      },
                      itemBuilder: (context, index) {
                        if (index < receiptData.length) {
                          return YjReceipt(spend: receiptData[index]);
                        } else {
                          return _buildAddReceiptPage();
                        }
                      },
                    ),
            ),
          ),
          receiptData.isNotEmpty
              ? Text(
                  "수정이 필요하다면?",
                  style: TextStyle(fontSize: 14, color: RECEIPT_TEXT_COLOR),
                )
              : SizedBox(
                  height: 0.h,
                ),
          receiptData.isNotEmpty
              ? SizedButton(
                  btnText: isEditing ? "저장" : "영수증 수정",
                  onPressed: () {
                    if (isEditing) {
                      setState(() {
                        isEditing = false;
                      });
                    } else {
                      final currentIndex = _pageController.page?.round();
                      if (currentIndex != null && currentIndex < receiptData.length) {
                        _navigateAndEditReceipt(context, currentIndex);
                      }
                      setState(() {
                        isEditing = true;
                      });
                    }
                  },
                )
              : SizedBox(
                  height: 0.h,
                )
        ],
      ),
    );
  }
}
