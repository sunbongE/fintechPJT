import 'dart:io';
import 'package:dio/dio.dart';
import 'package:front/repository/commons.dart';

final api = ApiClient();

// 프로필 사진 변경
Future<void> putProfileImage(data) async {
  try {
    final res = await api.put('/auth', data: data);
    return res.data;
  } catch (err) {
    print(err);
  }
}

// 회원 본인의 계좌 정보를 수정한다.
Future<void> putMyAccount(data) async {
  try {
    final res = await api.put('/members/account', data: data);
    return res.data;
  } catch (err) {
    print(err);
  }
}

// 이미지 업로드 요청
Future<dynamic> postUploadImage(formData) async {
  try {
    final res = await api.post("/members/profile", data: formData);
    return res.data;
  } catch (e) {
    throw Exception('Failed to post user info');
  }
}
