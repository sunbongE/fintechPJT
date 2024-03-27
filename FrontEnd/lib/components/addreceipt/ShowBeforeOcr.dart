import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
  final Function(List<Receipt>) onReceiptsUpdated;

  ShowBeforeOcr({
    Key? key,
    required this.onReceiptsUpdated,
  }) : super(key: key);

  @override
  State<ShowBeforeOcr> createState() => _ShowBeforeOcrState();
}

class _ShowBeforeOcrState extends State<ShowBeforeOcr> {
  List<Receipt> receiptData = [];
  List<bool> receiptSavedStates = [];

  final PageController _pageController = PageController();
  final ImagePicker picker = ImagePicker();

  double _progressValue = 0;
  int _currentPageIndex = 0;
  int countCheckReceipt = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    receiptSavedStates = List.generate(receiptData.length, (index) => false);
  }

  // 영수증 수정페이지로 이동 후 수정 사항 적용
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
        receiptSavedStates[index] = false;
      });
    }
  }

  // 영수증을 확인했다는 버튼
  void countCheckedReceipt(int index) {
    setState(() {
      receiptSavedStates[index] = !receiptSavedStates[index];

      if (receiptSavedStates.every((isSaved) => isSaved)) {
        widget.onReceiptsUpdated(receiptData);
      } else {
        widget.onReceiptsUpdated([]);
      }
    });
  }

  // 하단 모달
  void showModal() {
    print(receiptData);
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
    setState(() {
      isLoading = true;
    });

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

    // API 호출 및 응답 처리
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
      receiptSavedStates.add(false);
      isLoading = false;
      _currentPageIndex = receiptData.length - 1;
      _progressValue = (_currentPageIndex + 1) / (receiptData.length + 1);
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
          if (receiptData.isNotEmpty && _currentPageIndex < receiptData.length)
            Text(
              "옆으로 넘기면 새 영수증을 추가할 수 있습니다.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              textAlign: TextAlign.center,
            )
          else
            Text(
              "버튼을 눌러 영수증을 추가해보세요.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              textAlign: TextAlign.center,
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
                          _currentPageIndex = index;
                          _progressValue = (index + 1) / (receiptData.length + 1);
                        });
                      },
                      itemBuilder: (context, index) {
                        if (isLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (index >= receiptData.length) {
                          return _buildAddReceiptPage();
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                YjReceipt(spend: receiptData[index]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          receiptSavedStates[index] ? "다시 수정하려면?" : "수정이 완료되었다면?",
                                          style: TextStyle(fontSize: 14.sp, color: RECEIPT_TEXT_COLOR),
                                        ),
                                        SizedButton(
                                          btnText: receiptSavedStates[index] ? "영수증 저장 취소" : "영수증 저장",
                                          onPressed: () => countCheckedReceipt(index),
                                        )
                                      ],
                                    ),
                                    if (!receiptSavedStates[index])
                                      Column(
                                        children: [
                                          Text(
                                            "수정이 필요하다면?",
                                            style: TextStyle(fontSize: 14.sp, color: RECEIPT_TEXT_COLOR),
                                          ),
                                          SizedButton(
                                            btnText: "영수증 수정",
                                            onPressed: () => _navigateAndEditReceipt(context, index),
                                          )
                                        ],
                                      ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
