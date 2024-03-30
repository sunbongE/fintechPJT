import 'package:flutter/services.dart';
import 'package:front/providers/store.dart';
import 'package:front/repository/api/ApiLogin.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future<User?> SocialKakao() async {
  try {
    await UserApi.instance.loginWithKakaoAccount();
    User user = await UserApi.instance.me();
    return user;
  } catch (error) {
    print('카카오계정으로 로그인 실패 $error');
    return null;
  }
}

Future<void> logoutKakao() async {
  try {
    await UserApi.instance.logout();
    print("카카오 로그아웃 성공");
    await UserManager().clearUserInfo();
  } catch (error) {
    print("카카오 로그아웃 실패: $error");
  }
}
