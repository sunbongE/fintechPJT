import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

// Provider를 사용하기 위해서는 ChangeNotifier를 사용해서 클래스를 생성
// 로그인
class IsLogin with ChangeNotifier {
  // 스토리지 선언
  final storage = new FlutterSecureStorage();

  bool _isLogin = false;

  bool get isLogin => _isLogin;

  // save~~ 상태를 스토리지에 저장
  Future<void> saveLoginState(bool isLogin) async {
    await storage.write(key: '_isLogin', value: isLogin ? 'true' : 'false');
    _isLogin = isLogin;
    notifyListeners();
  }

  // load~~ 상태 스토리지에서 불러오기
  Future<void> loadLoginState() async {
    String? value = await storage.read(key: '_isLogin');
    _isLogin = value == 'true';
    notifyListeners();
  }

  // 로그인 상태 변경
  void loginState() {
    _isLogin = !_isLogin;
    notifyListeners();
  }
}

// 소셜로그인을 통해 받아온 UserInfo
// static으로 선언하여 어디서든 접근 가능하게
class UserInfo {
  static final storage = new FlutterSecureStorage();

  static String? name;
  static String? email;
  static String? thumbnail_image_url; // 110x110의 작은 사이즈
  static String? profile_image_url; // 640x640의 큰 사이즈

  static void updateUserInfo(User user) {
    name = user.kakaoAccount?.name;
    email = user.kakaoAccount?.email;
    thumbnail_image_url = user.kakaoAccount?.profile?.thumbnailImageUrl;
    profile_image_url = user.kakaoAccount?.profile?.profileImageUrl;
    saveUserInfo();
  }

  static Future<void> saveUserInfo() async {
    await storage.write(key: 'name', value: name);
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'thumbnail_image_url', value: thumbnail_image_url);
    await storage.write(key: 'profile_image_url', value: profile_image_url);
  }

  static Future<void> loadUserInfo() async {
    name = await storage.read(key: 'name');
    email = await storage.read(key: 'email');
    thumbnail_image_url = await storage.read(key: 'thumbnail_image_url');
    profile_image_url = await storage.read(key: 'profile_image_url');
  }
}

// 6자리 핀번호를 입력받은 비밀번호
class PassWord {
  static final storage = new FlutterSecureStorage();

  static String? password;

  static void updatePassWord(String? pw) {
    password = pw;
    savePassWord();
  }

  static Future<void> savePassWord() async {
    await storage.write(key: 'password', value: password);
  }

  static Future<void> loadUserInfo() async {
    password = await storage.read(key: 'password');
  }
}