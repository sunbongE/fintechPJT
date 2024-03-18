import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 모든 사용자 정보를 통합 관리하는 클래스
class UserManager with ChangeNotifier {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // 사용자 정보
  String? name;
  String? email;
  String? thumbnailImageUrl;
  String? profileImageUrl;
  String? jwtToken;

  // 비밀번호
  String? password;

  // 주 거래 은행 및 계좌 정보
  String? selectedBank;
  String? selectedAccount;

  // 로그인 상태
  bool _isLogin = false;
  bool get isLogin => _isLogin;

  static final UserManager _instance = UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  // 모든 사용자 정보 저장
  Future<void> saveUserInfo({
    String? newName,
    String? newEmail,
    String? newThumbnailImageUrl,
    String? newProfileImageUrl,
    String? newJwtToken,
    String? newPassword,
    String? newSelectedBank,
    String? newSelectedAccount,
  }) async {
    name = newName ?? name;
    email = newEmail ?? email;
    thumbnailImageUrl = newThumbnailImageUrl ?? thumbnailImageUrl;
    profileImageUrl = newProfileImageUrl ?? profileImageUrl;
    jwtToken = newJwtToken ?? jwtToken;
    password = newPassword ?? password;
    selectedBank = newSelectedBank ?? selectedBank;
    selectedAccount = newSelectedAccount ?? selectedAccount;

    await storage.write(key: 'name', value: name);
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'thumbnailImageUrl', value: thumbnailImageUrl);
    await storage.write(key: 'profileImageUrl', value: profileImageUrl);
    await storage.write(key: 'jwtToken', value: jwtToken);
    await storage.write(key: 'password', value: password);
    await storage.write(key: 'selectedBank', value: selectedBank);
    await storage.write(key: 'selectedAccount', value: selectedAccount);

    notifyListeners();
  }

  // 모든 사용자 정보 불러오기
  Future<void> loadUserInfo() async {
    name = await storage.read(key: 'name');
    email = await storage.read(key: 'email');
    thumbnailImageUrl = await storage.read(key: 'thumbnailImageUrl');
    profileImageUrl = await storage.read(key: 'profileImageUrl');
    jwtToken = await storage.read(key: 'jwtToken');
    password = await storage.read(key: 'password');
    selectedBank = await storage.read(key: 'selectedBank');
    selectedAccount = await storage.read(key: 'selectedAccount');
    String? isLoginString = await storage.read(key: 'isLogin');
    _isLogin = isLoginString == 'true';

    notifyListeners();
  }

  // 로그아웃 시 storage 초기화
  Future<void> clearUserInfo() async {
    name = null;
    email = null;
    thumbnailImageUrl = null;
    profileImageUrl = null;
    jwtToken = null;
    password = null;
    selectedBank = null;
    selectedAccount = null;
    _isLogin = false;
    await storage.deleteAll();

    notifyListeners();
  }

  // 로그인 상태 변경
  void updateLoginState(bool loginState) async {
    _isLogin = loginState;
    await storage.write(key: 'isLogin', value: loginState.toString());
    notifyListeners();
  }
}
