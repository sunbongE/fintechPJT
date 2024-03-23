import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:front/models/FlutterToastMsg.dart';
import 'package:image_picker/image_picker.dart';
import '../../entities/Receipt.dart';
import '../../repository/api/ApiReceipt.dart';
import '../../screen/YjReceipt.dart';

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
  Timer? _animationTimer;
  bool _isSwipeIconVisible = true;

  void _toggleAnimation(bool isLastPage) {
    if (isLastPage) {
      if (_animationTimer == null || !_animationTimer!.isActive) {
        _animationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _isSwipeIconVisible = !_isSwipeIconVisible;
          });
        });
      }
    } else {
      if (_animationTimer != null) {
        _animationTimer!.cancel();
        _animationTimer = null;
      }
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
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
                      receiptfromCamera();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('갤러리에서 가져오기'),
                  onTap: () {
                    Navigator.pop(context);
                    receiptfromGallary();
                  },
                ),
              ],
            ),
          );
        });
  }

  // 카메라로 사진찍기
  void receiptfromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      onImageSelected(image);
    }
  }

  // 갤러리에서 사진 가져오기
  void receiptfromGallary() async {
    final List<XFile>? selectedImages = await picker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      if (selectedImages.length > 10) {
        FlutterToastMsg('한 번에 최대 10장까지만 선택할 수 있습니다.');
        return;
      }
      for (XFile image in selectedImages) {
        onImageSelected(image);
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
    print("Response data: ${res.data}");

    Map<String, dynamic> jsonData = json.decode(res.data);
    Receipt receipt = Receipt.fromJson(jsonData);
    setState(() {
      receiptData.add(receipt);
    });
  }

  // 영수증이 없을 때의 페이지
  Widget _buildAddReceiptPage() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: PRIMARY_COLOR,
          width: 3.w,
        ),
      ),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextButton(
            onPressed: () => showModal(),
            child: Icon(
              Icons.add,
              color: PRIMARY_COLOR,
              size: 50.0.sp,
            ),
            style: TextButton.styleFrom(
              backgroundColor: BG_COLOR,
              minimumSize: Size(100.w, 100.h),
              shape: CircleBorder(),
            ),
          ),
          Positioned(
            bottom: 20.h,
            child: Visibility(
              visible: _isSwipeIconVisible,
              child: Icon(
                Icons.swipe,
                color: PRIMARY_COLOR,
                size: 30.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: receiptData.isEmpty
                  ? _buildAddReceiptPage()
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: receiptData.length + 1,
                      onPageChanged: (int index) {
                        setState(() {
                          _progressValue = index / (receiptData.length + 1);
                          _toggleAnimation(index == receiptData.length);
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
          LinearProgressIndicator(
            value: _progressValue,
            backgroundColor: BG_COLOR,
            valueColor: AlwaysStoppedAnimation<Color>(PRIMARY_COLOR),
          ),
        ],
      ),
    );
  }
}
